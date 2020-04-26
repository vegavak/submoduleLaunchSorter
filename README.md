# submoduleLaunchSorter
I made these scripts to help me organize and test mods every official update. (Since so many things keep breaking/crashing after patches).

These let you add a custom prefix to your mod names (which show up in any of the launchers) so you can sort, organize, and test without having to remember every one of the modules that are working/not.

Collection of scripts to backup, modify, and restore SubModule.XML for Bannerlord Modules. Currently targeting mods in the Vortex folder. Easily edited. This takes you through each mod and lets you classify them. You can customize what classifications you want. The way you use this is up to you.

If you have Vortex on your C:\ and are using hard links, you just need to open the PS1 in notepad and change the "$USER = ...." to your username. If you open CMD as administrator, type "Powershell" and then run the script in that window so you can see the output. So you should either be somewhat aware of how to use command prompt and navigate, or watch a video on it.

For editing classifications, just open the classify script and add or remove what you want. I tailored it to my needs.

Note: When you run the scripts- You might see some errors, but most are just because I'm lazy. Usually null method call errors. Anything else- just report to me. If you mess up- just reinstall the script from Vortex and try again.

1) BackupSubModules.ps1 - 
This is meant to be run once at first. This creates a copy to revert to.

2) RestoreSubModules.ps1
This uses all of the .BAK files that you created with #1 and reverts them.

3) ClassifySubModule.ps1 -
Indexes all of your submodule.XML's and reads the name value, prompts you to classify them. If you have previously classified them-- or if the module name starts with the classification -- it will skip it automatically.


Future thoughts:
You can add "First" and "Second" etc Categories to make sure your load order is always correct. That's also one way to use this.

It would be possible for mod creators to add an XML flag to pick up on classifications for-- to allow automatic sorting/customizations through launchers, but that requires a lot of buy in and coordination from the community.
