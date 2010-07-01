Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0GACcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:32:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52926 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0GACb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=xMgQc4HxOScGqxMacm2oQJXfakpev7NhAl1xdFqatVRObFowh/oeSwxY/rmewtqvYo
         zKQipTgdSBQUxsWtyUiVmaqBWaA/2xXndfxUX9WB4u0x4DrOS5a6Abu0EYAdkpckqUxC
         0rEtHSrOh9PuNq6s/ZiZPT1zmqyTQ0GGOgC7U=
MIME-Version: 1.0
From: CoffBeta <coffbeta@gmail.com>
Date: Thu, 1 Jul 2010 10:31:43 +0800
Message-ID: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com>
Subject: tq 2440
To: inux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       ext-jani.1.nikula@nokia.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOW, Booting Linux......
Uncompressing Linux.............................................................
s3c24xx_serial_initconsole
s3c24xx_serial_initconsole
s3c24xx_serial_init_ports: initialising ports...
s3c24xx_serial_init_port: port=c03939ec, platdev=c03a3700
s3c24xx_serial_init_port: c03939ec (hw 0)...
resource c0387c38 (50000000..50003fff)
port: map=50000000, mem=f5000000, irq=70, clock=1
s3c2440_serial_resetport: port=c03939ec (50000000), cfg=c03a367c
                                                               s3c24xx_serial_0
s3c24xx_serial_init_port: c0393a84 (hw 1)...
resource c0387c70 (50004000..50007fff)
port: map=50004000, mem=f5004000, irq=73, clock=1
s3c2440_serial_resetport: port=c0393a84 (50004000), cfg=c03a3698
s3c24xx_serial_init_port: port=c0393b1c, platdev=c0387e08
s3c24xx_serial_init_port: c0393b1c (hw 2)...
resource c0387ca8 (50008000..5000bfff)
port: map=50008000, mem=f5008000, irq=76, clock=1
s3c2440_serial_resetport: port=c0393b1c (50008000), cfg=c03a36b4
s3c24xx_serial_console_setup: co=c0393ba0 (0), <NULL>
s3c24xx_serial_console_setup: port=c03939ec (0)
s3c24xx_serial_get_options: port=c03939ec
registers: ulcon=00000003, ucon=000003c5, ubdriv=0000001a
calculated baud 115740
s3c24xx_serial_console_setup: baud 115740
config: 8bits/char
setting ulcon to 00000003, brddiv to 26
uart: ulcon = 0x00000003, ucon = 0x000003c5, ufcon = 0x00000051
Linux version 2.6.27-EmbedSky (ymcheng@ymcheng-desktop) (gcc version 4.3.3 (Sou0
CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=c0007177
Machine: SMDK2440
ATAG_INITRD is deprecated; please update your bootloader.
Memory policy: ECC disabled, Data cache writeback
CPU S3C2440A (id 0x32440001)
S3C244X: core 400.000 MHz, memory 100.000 MHz, peripheral 50.000 MHz
S3C24XX Clocks, (c) 2004 Simtec Electronics
CLOCK: Slow mode (1.500 MHz), fast, MPLL on, UPLL on
CPU0: D VIVT write-back cache
CPU0: I cache: 16384 bytes, associativity 64, 32 byte lines, 8 sets
CPU0: D cache: 16384 bytes, associativity 64, 32 byte lines, 8 sets
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: noinitrd root=/dev/mtdblock2 init=/linuxrc console=ttySAC0
irq: clearing pending ext status 00080000
irq: clearing subpending status 00000003
irq: clearing subpending status 00000002
PID hash table entries: 256 (order: 8, 1024 bytes)
timer tcon=00500000, tcnt a2c1, tcfg 00000200,00000000, usec 00001eb8
Console: colour dummy device 80x30
console [ttySAC0] enabled
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB = 64MB total
Memory: 60980KB available (3428K code, 303K data, 128K init)
Calibrating delay loop... 199.47 BogoMIPS (lpj=498688)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok

...............linux 2.6.27...............
net_namespace: 440 bytes
NET: Registered protocol family 16
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x30/0x44()
sysfs: duplicate filename 'dm9000.0' can not be created
Modules linked in:
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0046f70>] (warn_slowpath+0x64/0x80)
[<c0046f0c>] (warn_slowpath+0x0/0x80) from [<c00cdb74>] (sysfs_add_one+0x30/0x4)
 r3:c3841ea0 r2:c03396e6
 r6:c0389288 r5:c3849248 r4:ffffffef
[<c00cdb44>] (sysfs_add_one+0x0/0x44) from [<c00ce140>] (create_dir+0x58/0xa8)
 r5:c3849248 r4:c3819dc0
[<c00ce0e8>] (create_dir+0x0/0xa8) from [<c00ce1d0>] (sysfs_create_dir+0x40/0x6)
 r8:c0394128 r7:c03892ac r6:c0394128 r5:00000000 r4:c0389288
[<c00ce190>] (sysfs_create_dir+0x0/0x60) from [<c01334dc>] (kobject_add_interna)
 r4:c0389288
[<c013341c>] (kobject_add_internal+0x0/0x194) from [<c013368c>] (kobject_add_va)
 r9:00000000 r8:c03892ac r7:c03892ac r6:c0394128 r5:00000000
r4:c0389288
[<c013364c>] (kobject_add_varg+0x0/0x50) from [<c0133738>] (kobject_add+0x58/0x)
 r7:c03892ac r6:c0389218 r5:c0389220 r4:00000054
[<c01336e0>] (kobject_add+0x0/0x64) from [<c0175de0>] (device_add+0x78/0x50c)
 r3:c03892ac r2:c0355bea
[<c0175d68>] (device_add+0x0/0x50c) from [<c017932c>] (platform_device_add+0x10)
[<c017922c>] (platform_device_add+0x0/0x150) from [<c017939c>] (platform_device)
 r7:00000006 r6:00000000 r5:c002514c r4:c0389218
[<c017937c>] (platform_device_register+0x0/0x24) from [<c0179594>] (platform_ad)
 r5:c002514c r4:00000005
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
kobject_add_internal failed for dm9000.0 with -EEXIST, don't try to register th.
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0133568>] (kobject_add_internal+0x14)
[<c013341c>] (kobject_add_internal+0x0/0x194) from [<c013368c>] (kobject_add_va)
 r9:00000000 r8:c03892ac r7:c03892ac r6:c0394128 r5:00000000
r4:c0389288
[<c013364c>] (kobject_add_varg+0x0/0x50) from [<c0133738>] (kobject_add+0x58/0x)
 r7:c03892ac r6:c0389218 r5:c0389220 r4:00000054
[<c01336e0>] (kobject_add+0x0/0x64) from [<c0175de0>] (device_add+0x78/0x50c)
 r3:c03892ac r2:c0355bea
[<c0175d68>] (device_add+0x0/0x50c) from [<c017932c>] (platform_device_add+0x10)
[<c017922c>] (platform_device_add+0x0/0x150) from [<c017939c>] (platform_device)
 r7:00000006 r6:00000000 r5:c002514c r4:c0389218
[<c017937c>] (platform_device_register+0x0/0x24) from [<c0179594>] (platform_ad)
 r5:c002514c r4:00000005
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
Device 's3c24xx_led.3' does not have a release() function, it is broken and mus.
Modules linked in:
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0046f70>] (warn_slowpath+0x64/0x80)
[<c0046f0c>] (warn_slowpath+0x0/0x80) from [<c01753b0>] (device_release+0x6c/0x)
 r3:c0389184 r2:c0349209
 r6:c3841f80 r5:c0393f70 r4:c0389160
[<c0175344>] (device_release+0x0/0x78) from [<c0133384>] (kobject_release+0x5c/)
[<c0133328>] (kobject_release+0x0/0x70) from [<c01340a8>] (kref_put+0x68/0x78)
 r7:00000006 r6:ffffffef r5:c0133328 r4:c038917c
[<c0134040>] (kref_put+0x0/0x78) from [<c0133268>] (kobject_put+0x48/0x60)
 r5:c0025158 r4:c0389160
[<c0133220>] (kobject_put+0x0/0x60) from [<c0174f48>] (put_device+0x1c/0x20)
 r4:c03890f0
[<c0174f2c>] (put_device+0x0/0x20) from [<c01794e8>] (platform_device_put+0x1c/)
[<c01794cc>] (platform_device_put+0x0/0x20) from [<c017956c>] (platform_device_)
[<c0179550>] (platform_device_unregister+0x0/0x20) from [<c01795b0>] (platform_)
 r5:c0025158 r4:00000004
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
Device 's3c24xx_led.2' does not have a release() function, it is broken and mus.
Modules linked in:
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0046f70>] (warn_slowpath+0x64/0x80)
[<c0046f0c>] (warn_slowpath+0x0/0x80) from [<c01753b0>] (device_release+0x6c/0x)
 r3:c038905c r2:c0349209
 r6:c3841220 r5:c0393f70 r4:c0389038
[<c0175344>] (device_release+0x0/0x78) from [<c0133384>] (kobject_release+0x5c/)
[<c0133328>] (kobject_release+0x0/0x70) from [<c01340a8>] (kref_put+0x68/0x78)
 r7:00000006 r6:ffffffef r5:c0133328 r4:c0389054
[<c0134040>] (kref_put+0x0/0x78) from [<c0133268>] (kobject_put+0x48/0x60)
 r5:c0025154 r4:c0389038
[<c0133220>] (kobject_put+0x0/0x60) from [<c0174f48>] (put_device+0x1c/0x20)
 r4:c0388fc8
[<c0174f2c>] (put_device+0x0/0x20) from [<c01794e8>] (platform_device_put+0x1c/)
[<c01794cc>] (platform_device_put+0x0/0x20) from [<c017956c>] (platform_device_)
[<c0179550>] (platform_device_unregister+0x0/0x20) from [<c01795b0>] (platform_)
 r5:c0025154 r4:00000003
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
Device 's3c24xx_led.1' does not have a release() function, it is broken and mus.
Modules linked in:
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0046f70>] (warn_slowpath+0x64/0x80)
[<c0046f0c>] (warn_slowpath+0x0/0x80) from [<c01753b0>] (device_release+0x6c/0x)
 r3:c0388f34 r2:c0349209
 r6:c38412e0 r5:c0393f70 r4:c0388f10
[<c0175344>] (device_release+0x0/0x78) from [<c0133384>] (kobject_release+0x5c/)
[<c0133328>] (kobject_release+0x0/0x70) from [<c01340a8>] (kref_put+0x68/0x78)
 r7:00000006 r6:ffffffef r5:c0133328 r4:c0388f2c
[<c0134040>] (kref_put+0x0/0x78) from [<c0133268>] (kobject_put+0x48/0x60)
 r5:c0025150 r4:c0388f10
[<c0133220>] (kobject_put+0x0/0x60) from [<c0174f48>] (put_device+0x1c/0x20)
 r4:c0388ea0
[<c0174f2c>] (put_device+0x0/0x20) from [<c01794e8>] (platform_device_put+0x1c/)
[<c01794cc>] (platform_device_put+0x0/0x20) from [<c017956c>] (platform_device_)
[<c0179550>] (platform_device_unregister+0x0/0x20) from [<c01795b0>] (platform_)
 r5:c0025150 r4:00000002
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
Device 's3c24xx_led.0' does not have a release() function, it is broken and mus.
Modules linked in:
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0046f70>] (warn_slowpath+0x64/0x80)
[<c0046f0c>] (warn_slowpath+0x0/0x80) from [<c01753b0>] (device_release+0x6c/0x)
 r3:c0388e0c r2:c0349209
 r6:c38413a0 r5:c0393f70 r4:c0388de8
[<c0175344>] (device_release+0x0/0x78) from [<c0133384>] (kobject_release+0x5c/)
[<c0133328>] (kobject_release+0x0/0x70) from [<c01340a8>] (kref_put+0x68/0x78)
 r7:00000006 r6:ffffffef r5:c0133328 r4:c0388e04
[<c0134040>] (kref_put+0x0/0x78) from [<c0133268>] (kobject_put+0x48/0x60)
 r5:c002514c r4:c0388de8
[<c0133220>] (kobject_put+0x0/0x60) from [<c0174f48>] (put_device+0x1c/0x20)
 r4:c0388d78
[<c0174f2c>] (put_device+0x0/0x20) from [<c01794e8>] (platform_device_put+0x1c/)
[<c01794cc>] (platform_device_put+0x0/0x20) from [<c017956c>] (platform_device_)
[<c0179550>] (platform_device_unregister+0x0/0x20) from [<c01795b0>] (platform_)
 r5:c002514c r4:00000001
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
Device 's3c2440-nand' does not have a release() function, it is broken and must.
Modules linked in:
[<c02a4bf8>] (dump_stack+0x0/0x14) from [<c0046f70>] (warn_slowpath+0x64/0x80)
[<c0046f0c>] (warn_slowpath+0x0/0x80) from [<c01753b0>] (device_release+0x6c/0x)
 r3:c0387014 r2:c0349209
 r6:c3841460 r5:c0393f70 r4:c0386ff0
[<c0175344>] (device_release+0x0/0x78) from [<c0133384>] (kobject_release+0x5c/)
[<c0133328>] (kobject_release+0x0/0x70) from [<c01340a8>] (kref_put+0x68/0x78)
 r7:00000006 r6:ffffffef r5:c0133328 r4:c038700c
[<c0134040>] (kref_put+0x0/0x78) from [<c0133268>] (kobject_put+0x48/0x60)
 r5:c0025148 r4:c0386ff0
[<c0133220>] (kobject_put+0x0/0x60) from [<c0174f48>] (put_device+0x1c/0x20)
 r4:c0386f80
[<c0174f2c>] (put_device+0x0/0x20) from [<c01794e8>] (platform_device_put+0x1c/)
[<c01794cc>] (platform_device_put+0x0/0x20) from [<c017956c>] (platform_device_)
[<c0179550>] (platform_device_unregister+0x0/0x20) from [<c01795b0>] (platform_)
 r5:c0025148 r4:00000000
[<c0179570>] (platform_add_devices+0x0/0x68) from [<c0011b50>] (smdk_machine_in)
 r7:c000e6ac r6:00000000 r5:00000000 r4:c0024ebc
[<c0011acc>] (smdk_machine_init+0x0/0x98) from [<c0010950>] (smdk2440_machine_i)
[<c0010928>] (smdk2440_machine_init+0x0/0x54) from [<c000e6cc>] (customize_mach)
 r5:00000000 r4:c00226c4
[<c000e6ac>] (customize_machine+0x0/0x2c) from [<c00282c0>] (do_one_initcall+0x)
[<c0028268>] (do_one_initcall+0x0/0x180) from [<c00085c4>] (kernel_init+0x88/0x)
[<c000853c>] (kernel_init+0x0/0xfc) from [<c0049fa8>] (do_exit+0x0/0x6bc)
 r4:00000000
---[ end trace 1b75b31a2719ed1c ]---
S3C2410 Power Management, (c) 2004 Simtec Electronics
S3C2440: Initialising architecture
S3C2440: IRQ Support
S3C24XX DMA Driver, (c) 2003-2004,2006 Simtec Electronics
DMA channel 0 at c4800000, irq 33
DMA channel 1 at c4800040, irq 34
DMA channel 2 at c4800080, irq 35
DMA channel 3 at c48000c0, irq 36
S3C244X: Clock Support, DVS off
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
NET: Registered protocol family 1
NetWinder Floating Point Emulator V0.97 (extended precision)
JFFS2 version 2.2. (NAND) (SUMMARY)  �© 2001-2006 Red Hat, Inc.
yaffs Jun  7 2010 15:39:55 Installing.
msgmni has been set to 119
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Console: switching to colour frame buffer device 40x30
fb0: s3c2410fb frame buffer device
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
s3c24xx_serial_init(c0393c44,c0393c94)
s3c24xx_serial_init(c0393cc4,c0393d14)
s3c2440_serial_probe: dev=c03a3700
s3c24xx_serial_probe(c03a3700, c0393d14) 0
s3c24xx_serial_probe: initialising port c03939d8...
s3c24xx_serial_init_port: port=c03939ec, platdev=c03a3700
s3c24xx_serial_probe: adding port
s3c2440-uart.0: tq2440_serial0 at MMIO 0x50000000 (irq = 70) is a S3C2440
s3c2440_serial_probe: dev=c0387ce0
s3c24xx_serial_probe(c0387ce0, c0393d14) 1
s3c24xx_serial_probe: initialising port c0393a70...
s3c24xx_serial_init_port: port=c0393a84, platdev=c0387ce0
s3c24xx_serial_probe: adding port
s3c2440-uart.1: tq2440_serial1 at MMIO 0x50004000 (irq = 73) is a S3C2440
s3c2440_serial_probe: dev=c0387e08
s3c24xx_serial_probe(c0387e08, c0393d14) 2
s3c24xx_serial_probe: initialising port c0393b08...
s3c24xx_serial_init_port: port=c0393b1c, platdev=c0387e08
s3c24xx_serial_probe: adding port
s3c2440-uart.2: tq2440_serial2 at MMIO 0x50008000 (irq = 76) is a S3C2440
brd: module loaded
loop: module loaded
dm9000 Ethernet Driver, V1.31
Now use the default MAC address: 10:23:45:67:89:ab
dm9000 dm9000.0: eth%d: Invalid ethernet MAC address. Please set using ifconfig
eth0: dm9000e at c485e000,c4860004 IRQ 51 MAC: 00:00:00:00:00:00 (chip)
Uniform Multi-Platform E-IDE driver
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
S3C24XX NAND Driver, (c) 2004 Simtec Electronics
usbmon: debugfs is not available
s3c2410-ohci s3c2410-ohci: S3C24XX OHCI
s3c2410-ohci s3c2410-ohci: new USB bus registered, assigned bus number 1
s3c2410-ohci s3c2410-ohci: irq 42, io mem 0x49000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver usbserial
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
mice: PS/2 mouse device common for all mice
S3C24XX RTC, (c) 2004,2006 Simtec Electronics
i2c /dev entries driver
s3c2440-i2c s3c2440-i2c: slave address 0x10
s3c2440-i2c s3c2440-i2c: bus frequency set to 390 KHz
s3c2440-i2c s3c2440-i2c: i2c-0: S3C I2C adapter
S3C2410 Watchdog Timer, (c) 2004 Simtec Electronics
s3c2410-wdt s3c2410-wdt: watchdog inactive, reset disabled, irq enabled
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.17.
ALSA device list:
 No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Root-NFS: No NFS server available, giving up.
VFS: Unable to mount root fs via NFS, trying floppy.
VFS: Cannot open root device "mtdblock2" or unknown-block(2,0)
Please append a correct "root=" boot option; here are the available partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)







all the above is my start information.I don't know why can't able to
mount root fs?how
can I do? Thanks
