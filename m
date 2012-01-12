Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2ALUkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:40:21 -0500
Received: from snt0-omc1-s43.snt0.hotmail.com ([65.54.61.80]:6591 "EHLO
	snt0-omc1-s43.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381Ab2ALUkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:40:19 -0500
Message-ID: <SNT123-W206618A1B501B8A491DFADDB9F0@phx.gbl>
X-Originating-IP: [173.161.69.124]
From: Greg White <pcguy11@live.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-usb@vger.kernel.org>
Subject: =?windows-1256?Q?MULTIPLE_W?= =?windows-1256?Q?ARNING:_at?=
 =?windows-1256?Q?_fs/sysfs/?= =?windows-1256?Q?dir.c:455_?=
 =?windows-1256?Q?sysfs=5Fadd=5F?= =?windows-1256?Q?one=FE=FE?=
Date: Thu, 12 Jan 2012 14:40:18 -0600
Importance: Normal
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Jan 2012 20:40:18.0286 (UTC) FILETIME=[654808E0:01CCD16A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
 
I just installed Linux on my HP 6200 PC using UEFI. The Ubuntu lucid kernel caused my computer to freeze during shutdown and reboots. So I downloaded 3.1.6 from kernel.org and compiled my own kernel and it works fine except for the following messages in my dmesg:
 
[2.295957] ------------[ cut here ]------------
[2.295962] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
[2.295964] Hardware name: HP Compaq 6200 Pro Small Form Factor
[2.295966] sysfs: cannot create duplicate filename '/firmware/efi/vars/SlotPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[2.295969] Modules linked in:
[2.295972] Pid: 1, comm: swapper Not tainted 3.1.6 #1
[2.295974] Call Trace:
[2.295979] [<ffffffff81061c4f>] warn_slowpath_common+0x7f/0xc0
[2.295982] [<ffffffff81061d46>] warn_slowpath_fmt+0x46/0x50
[2.295985] [<ffffffff811c6a91>] sysfs_add_one+0xc1/0xf0
[2.295988] [<ffffffff811c6b41>] create_dir+0x81/0xd0
[2.295991] [<ffffffff811c6c0d>] sysfs_create_dir+0x7d/0xd0
[2.295995] [<ffffffff812fc6d7>] kobject_add_internal+0xb7/0x200
[2.295998] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296001] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296004] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296008] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296011] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296016] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296019] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296023] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296026] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296030] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296033] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296036] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296041] ---[ end trace 629518364de3e84b ]---
[2.296043] kobject_add_internal failed for 
SlotPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9 with -EEXIST, don't try to register things with the same name in the same directory.
[2.296048] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296050] Call Trace:
[2.296052] [<ffffffff812fc77d>] kobject_add_internal+0x15d/0x200
[2.296055] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296058] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296061] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296064] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296067] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296070] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296073] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296076] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296079] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296082] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296085] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296088] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296167] ------------[ cut here ]------------
[2.296170] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
[2.296172] Hardware name: HP Compaq 6200 Pro Small Form Factor
[2.296174] sysfs: cannot create duplicate filename '/firmware/efi/vars/FrontUsbPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[2.296177] Modules linked in:
[2.296179] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296181] Call Trace:
[2.296184] [<ffffffff81061c4f>] warn_slowpath_common+0x7f/0xc0
[2.296187] [<ffffffff81061d46>] warn_slowpath_fmt+0x46/0x50
[2.296190] [<ffffffff811c6a91>] sysfs_add_one+0xc1/0xf0
[2.296193] [<ffffffff811c6b41>] create_dir+0x81/0xd0
[2.296195] [<ffffffff811c6c0d>] sysfs_create_dir+0x7d/0xd0
[2.296199] [<ffffffff812fc6d7>] kobject_add_internal+0xb7/0x200
[2.296202] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296204] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296207] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296210] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296213] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296216] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296219] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296222] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296225] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296228] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296231] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296233] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296236] ---[ end trace 629518364de3e84c ]---
[2.296249] kobject_add_internal failed for 
FrontUsbPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9 with -EEXIST, don't try to register things with the same name in the same directory.
[2.296254] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296256] Call Trace:
[2.296259] [<ffffffff812fc77d>] kobject_add_internal+0x15d/0x200
[2.296262] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296265] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296267] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296270] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296273] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296276] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296279] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296282] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296285] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296287] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296291] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296293] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296372] ------------[ cut here ]------------
[2.296374] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
[2.296376] Hardware name: HP Compaq 6200 Pro Small Form Factor
[2.296378] sysfs: cannot create duplicate filename '/firmware/efi/vars/RearUsbPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[2.296382] Modules linked in:
[2.296383] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296385] Call Trace:
[2.296388] [<ffffffff81061c4f>] warn_slowpath_common+0x7f/0xc0
[2.296391] [<ffffffff81061d46>] warn_slowpath_fmt+0x46/0x50
[2.296394] [<ffffffff811c6a91>] sysfs_add_one+0xc1/0xf0
[2.296397] [<ffffffff811c6b41>] create_dir+0x81/0xd0
[2.296400] [<ffffffff811c6c0d>] sysfs_create_dir+0x7d/0xd0
[2.296403] [<ffffffff812fc6d7>] kobject_add_internal+0xb7/0x200
[2.296406] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296409] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296411] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296414] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296417] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296420] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296423] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296426] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296429] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296431] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296435] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296437] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296439] ---[ end trace 629518364de3e84d ]---
[2.296441] kobject_add_internal failed for 
RearUsbPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9 with -EEXIST, don't try to register things with the same name in the same directory.
[2.296446] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296448] Call Trace:
[2.296450] [<ffffffff812fc77d>] kobject_add_internal+0x15d/0x200
[2.296453] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296456] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296459] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296461] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296464] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296468] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296471] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296474] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296477] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296479] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296482] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296485] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296563] ------------[ cut here ]------------
[2.296565] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
[2.296568] Hardware name: HP Compaq 6200 Pro Small Form Factor
[2.296570] sysfs: cannot create duplicate filename '/firmware/efi/vars/InternalUsbPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[2.296573] Modules linked in:
[2.296575] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296577] Call Trace:
[2.296579] [<ffffffff81061c4f>] warn_slowpath_common+0x7f/0xc0
[2.296582] [<ffffffff81061d46>] warn_slowpath_fmt+0x46/0x50
[2.296585] [<ffffffff811c6a91>] sysfs_add_one+0xc1/0xf0
[2.296588] [<ffffffff811c6b41>] create_dir+0x81/0xd0
[2.296591] [<ffffffff811c6c0d>] sysfs_create_dir+0x7d/0xd0
[2.296594] [<ffffffff812fc6d7>] kobject_add_internal+0xb7/0x200
[2.296597] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296600] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296602] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296605] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296608] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296611] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296614] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296617] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296620] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296623] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296626] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296628] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296630] ---[ end trace 629518364de3e84e ]---
[2.296632] kobject_add_internal failed for 
InternalUsbPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9 with -EEXIST, don't try to register things with the same name in the same directory.
[2.296637] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296639] Call Trace:
[2.296641] [<ffffffff812fc77d>] kobject_add_internal+0x15d/0x200
[2.296644] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296647] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296650] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296653] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296655] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296659] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296662] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296665] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296668] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296670] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296673] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296676] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296754] ------------[ cut here ]------------
[2.296756] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
[2.296758] Hardware name: HP Compaq 6200 Pro Small Form Factor
[2.296760] sysfs: cannot create duplicate filename '/firmware/efi/vars/SetupFeatureSupport-b6ad93e3-19f7-4c85-aa72-80c57194dbc7'
[2.296763] Modules linked in:
[2.296765] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296767] Call Trace:
[2.296770] [<ffffffff81061c4f>] warn_slowpath_common+0x7f/0xc0
[2.296773] [<ffffffff81061d46>] warn_slowpath_fmt+0x46/0x50
[2.296776] [<ffffffff811c6a91>] sysfs_add_one+0xc1/0xf0
[2.296778] [<ffffffff811c6b41>] create_dir+0x81/0xd0
[2.296781] [<ffffffff811c6c0d>] sysfs_create_dir+0x7d/0xd0
[2.296784] [<ffffffff812fc6d7>] kobject_add_internal+0xb7/0x200
[2.296787] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296790] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296793] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296795] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296798] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296801] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296804] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296807] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296810] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296813] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296816] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296819] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
[2.296821] ---[ end trace 629518364de3e84f ]---
[2.296823] kobject_add_internal failed for 
SetupFeatureSupport-b6ad93e3-19f7-4c85-aa72-80c57194dbc7 with -EEXIST, don't try to register things with the same name in the same directory.
[2.296827] Pid: 1, comm: swapper Tainted: G    W  3.1.6 #1
[2.296829] Call Trace:
[2.296832] [<ffffffff812fc77d>] kobject_add_internal+0x15d/0x200
[2.296835] [<ffffffff812fc938>] kobject_add_varg+0x38/0x60
[2.296838] [<ffffffff812fc9b3>] kobject_init_and_add+0x53/0x70
[2.296840] [<ffffffff81304f10>] ? sprintf+0x40/0x50
[2.296843] [<ffffffff814d8184>] efivar_create_sysfs_entry+0x124/0x1b0
[2.296846] [<ffffffff814d8929>] register_efivars+0xc9/0x3c0
[2.296849] [<ffffffff81cfeb55>] ? edd_init+0x355/0x355
[2.296852] [<ffffffff81cfebfe>] efivars_init+0xa9/0xf7
[2.296855] [<ffffffff81002043>] do_one_initcall+0x43/0x190
[2.296858] [<ffffffff81cc3680>] kernel_init+0xcd/0x151
[2.296860] [<ffffffff815fbe74>] kernel_thread_helper+0x4/0x10
[2.296864] [<ffffffff81cc35b3>] ? parse_early_options+0x20/0x20
[2.296866] [<ffffffff815fbe70>] ? gs_change+0x13/0x13
 
I can email the full dmesg and kernel config. If you need anything else please email me as I am not subscribed to the list.
 
Thanks,
Greg 		 	   		  
  		 	   		  
