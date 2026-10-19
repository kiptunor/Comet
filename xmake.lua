add_rules("mode.debug", "mode.release", "plugin.compile_commands.autoupdate")


function copy_assets(target)
    os.cp("assets", target:targetdir())
end


set_languages("cxx20")
add_includedirs(".", "src", {public = true})

add_requires("imgui", {
    configs = {
        glfw_opengl3 = true
    }
})
add_requires("glfw", "glad", "glm", "miniz", "rtmidi", "yaml-cpp", "tbb", "nativefiledialog", "libcurl")

target("Comet")
    add_files("**.cpp")
    -- add_files("external/nfd/*.c")
    add_includedirs("external/bass", "external/bassmidi")
    
    remove_files("assets/ColorPalette/*") -- idk why there are some source files duplicated

    add_packages("glfw", "glad", "glm", "imgui", "miniz", "rtmidi", "yaml-cpp", "tbb", "nativefiledialog", "libcurl")
    
    if is_plat("linux") then
        add_linkdirs("external/bass/linux", "external/bassmidi/linux")
        add_links("bass", "bassmidi")
        add_syslinks("GL")
    elseif is_plat("windows") then
        add_linkdirs("external/bass/win32", "external/bassmidi/win32")
        add_links("bass", "bassmidi")
        add_syslinks("opengl32")
    end

    after_build(copy_assets)