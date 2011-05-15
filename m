Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181Ab1EORCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:02:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65314 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab1EORCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GokaaVjHwWsSv1KiCFiJGoeHFq5jcbHPG3qvQLLiV0+/q8S6TReMt6GIoKSqBR6e4p
         D1MSvPWxtC5CxRQQWm5z/T4tqkcCY5CqwPWaKoknXcoBL1cCm1qGfHr0ibzRLsvGB8Rl
         y5UrvA5fkMP/R1NdIlLrKme2TZyIaOtPVfRoE=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc7-git1 boot error message (no crash)
Date: Sun, 15 May 2011 19:02:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc6; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <web-520830057@zbackend1.aha.ru>
In-Reply-To: <web-520830057@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105151902.27434.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=35142
for your bug report, please add your address to the CC list in there, thanks!

On środa, 11 maja 2011 o 06:58:11 werner wrote:
> Below an error message during boot, on a Qosmio Toshiba
> Laptop of a neighbour, no crash and normal working.  On a
> Packard-Bell laptop of another person, nor on my own
> computer, occurs this error message.
> 
> Probably not important.
> 
> For avaliation / check / correction.
> 
> 
> W.Landgraf
> 
> 
> ================
> May 11 01:01:46 localhost kernel: ------------[ cut here
> ]------------
> May 11 01:01:46 localhost kernel: WARNING: at
> fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
> May 11 01:01:46 localhost kernel: Hardware name: Qosmio
> E10
> May 11 01:01:46 localhost kernel: sysfs: cannot create
> duplicate filename
> '/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
> May 11 01:01:46 localhost kernel: Modules linked in:
> May 11 01:01:46 localhost kernel: Pid: 1, comm: swapper
> Not tainted 2.6.39-rc7-git1-i486-1sys #1
> May 11 01:01:46 localhost kernel: Call Trace:
> May 11 01:01:46 localhost kernel:  [<c112d5e2>] ?
> sysfs_add_one+0x83/0x95
> May 11 01:01:46 localhost kernel:  [<c1040e25>]
> warn_slowpath_common+0x7a/0x8f
> May 11 01:01:46 localhost kernel:  [<c112d5e2>] ?
> sysfs_add_one+0x83/0x95
> May 11 01:01:46 localhost kernel:  [<c1040ec5>]
> warn_slowpath_fmt+0x33/0x35
> May 11 01:01:46 localhost kernel:  [<c112d5e2>]
> sysfs_add_one+0x83/0x95
> May 11 01:01:46 localhost kernel:  [<c112cfd8>]
> sysfs_add_file_mode+0x4a/0x72
> May 11 01:01:46 localhost kernel:  [<c112d018>]
> sysfs_add_file+0x18/0x1c
> May 11 01:01:46 localhost kernel:  [<c112d0b3>]
> sysfs_create_file+0x25/0x27
> May 11 01:01:46 localhost kernel:  [<c1792ac8>]
> device_create_file+0x18/0x1a
> May 11 01:01:46 localhost kernel:  [<c1693b3a>]
> create_regulator+0xd8/0x21d
> May 11 01:01:46 localhost kernel:  [<c1693dde>]
> _regulator_get+0x15f/0x1ba
> May 11 01:01:46 localhost kernel:  [<c1693e5c>]
> regulator_get+0xf/0x11
> May 11 01:01:46 localhost kernel:  [<c1cd492d>]
> sdhci_add_host+0x586/0x6d1
> May 11 01:01:46 localhost kernel:  [<c15945ab>] ?
> pci_ioremap_bar+0x5b/0x60
> May 11 01:01:46 localhost kernel:  [<c1eb3c28>]
> sdhci_pci_probe_slot+0x1c1/0x204
> May 11 01:01:46 localhost kernel:  [<c1eb3d71>] ?
> sdhci_pci_probe+0x106/0x1cd
> May 11 01:01:46 localhost kernel:  [<c1eb3dd9>]
> sdhci_pci_probe+0x16e/0x1cd
> May 11 01:01:46 localhost kernel:  [<c15947dd>]
> local_pci_probe+0x41/0x85
> May 11 01:01:46 localhost kernel:  [<c1595352>]
> pci_device_probe+0x48/0x6b
> May 11 01:01:46 localhost kernel:  [<c1794899>]
> really_probe+0x7f/0x11c
> May 11 01:01:46 localhost kernel:  [<c179b256>] ?
> pm_runtime_barrier+0x4d/0x79
> May 11 01:01:46 localhost kernel:  [<c1794967>]
> driver_probe_device+0x31/0x46
> May 11 01:01:46 localhost kernel:  [<c17949c4>]
> __driver_attach+0x48/0x64
> May 11 01:01:46 localhost kernel:  [<c17941f6>]
> bus_for_each_dev+0x42/0x6c
> May 11 01:01:46 localhost kernel:  [<c179473f>]
> driver_attach+0x1e/0x20
> May 11 01:01:46 localhost kernel:  [<c179497c>] ?
> driver_probe_device+0x46/0x46
> May 11 01:01:46 localhost kernel:  [<c1793c0b>]
> bus_add_driver+0xc6/0x20a
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c1794eef>]
> driver_register+0x98/0xf8
> May 11 01:01:46 localhost kernel:  [<c1794eef>] ?
> driver_register+0x98/0xf8
> May 11 01:01:46 localhost kernel:  [<c1695525>] ?
> tty_register_driver+0x15e/0x1e2
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c1595541>]
> __pci_register_driver+0x3d/0x96
> May 11 01:01:46 localhost kernel:  [<c1ec9c37>] ?
> printk+0x1d/0x1f
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c24ba7de>]
> sdhci_drv_init+0x14/0x16
> May 11 01:01:46 localhost kernel:  [<c1001174>]
> do_one_initcall+0x8c/0x142
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c1082dfc>] ?
> irq_to_desc+0x8/0x1e
> May 11 01:01:46 localhost kernel:  [<c24ba7ca>] ?
> sdhci_drv_init+0x22/0x22
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c245b293>]
> kernel_init+0x96/0x12a
> May 11 01:01:46 localhost kernel:  [<c1ecd4c6>]
> kernel_thread_helper+0x6/0x10
> May 11 01:01:46 localhost kernel: ---[ end trace
> acbbad639e5c6e5b ]---
> May 11 01:01:46 localhost kernel: create_regulator: dummy:
> could not add regulator_dev requested microamps sysfs
> entry
> May 11 01:01:46 localhost kernel: _regulator_get:
> 0000:02:0b.4 supply vmmc not found, using dummy regulator
> May 11 01:01:46 localhost kernel: ------------[ cut here
> ]------------
> May 11 01:01:46 localhost kernel: WARNING: at
> fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
> May 11 01:01:46 localhost kernel: Hardware name: Qosmio
> E10
> May 11 01:01:46 localhost kernel: sysfs: cannot create
> duplicate filename
> '/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
> May 11 01:01:46 localhost kernel: Modules linked in:
> May 11 01:01:46 localhost kernel: Pid: 1, comm: swapper
> Tainted: G        W   2.6.39-rc7-git1-i486-1sys #1
> May 11 01:01:46 localhost kernel: Call Trace:
> May 11 01:01:46 localhost kernel:  [<c112d5e2>] ?
> sysfs_add_one+0x83/0x95
> May 11 01:01:46 localhost kernel:  [<c1040e25>]
> warn_slowpath_common+0x7a/0x8f
> May 11 01:01:46 localhost kernel:  [<c112d5e2>] ?
> sysfs_add_one+0x83/0x95
> May 11 01:01:46 localhost kernel:  [<c1040ec5>]
> warn_slowpath_fmt+0x33/0x35
> May 11 01:01:46 localhost kernel:  [<c112d5e2>]
> sysfs_add_one+0x83/0x95
> May 11 01:01:46 localhost kernel:  [<c112cfd8>]
> sysfs_add_file_mode+0x4a/0x72
> May 11 01:01:46 localhost kernel:  [<c112d018>]
> sysfs_add_file+0x18/0x1c
> May 11 01:01:46 localhost kernel:  [<c112d0b3>]
> sysfs_create_file+0x25/0x27
> May 11 01:01:46 localhost kernel:  [<c1792ac8>]
> device_create_file+0x18/0x1a
> May 11 01:01:46 localhost kernel:  [<c1693b3a>]
> create_regulator+0xd8/0x21d
> May 11 01:01:46 localhost kernel:  [<c1693dde>]
> _regulator_get+0x15f/0x1ba
> May 11 01:01:46 localhost kernel:  [<c1693e5c>]
> regulator_get+0xf/0x11
> May 11 01:01:46 localhost kernel:  [<c1cd492d>]
> sdhci_add_host+0x586/0x6d1
> May 11 01:01:46 localhost kernel:  [<c15945ab>] ?
> pci_ioremap_bar+0x5b/0x60
> May 11 01:01:46 localhost kernel:  [<c1eb3c28>]
> sdhci_pci_probe_slot+0x1c1/0x204
> May 11 01:01:46 localhost kernel:  [<c1eb3d71>] ?
> sdhci_pci_probe+0x106/0x1cd
> May 11 01:01:46 localhost kernel:  [<c1eb3dd9>]
> sdhci_pci_probe+0x16e/0x1cd
> May 11 01:01:46 localhost kernel:  [<c15947dd>]
> local_pci_probe+0x41/0x85
> May 11 01:01:46 localhost kernel:  [<c1595352>]
> pci_device_probe+0x48/0x6b
> May 11 01:01:46 localhost kernel:  [<c1794899>]
> really_probe+0x7f/0x11c
> May 11 01:01:46 localhost kernel:  [<c179b256>] ?
> pm_runtime_barrier+0x4d/0x79
> May 11 01:01:46 localhost kernel:  [<c1794967>]
> driver_probe_device+0x31/0x46
> May 11 01:01:46 localhost kernel:  [<c17949c4>]
> __driver_attach+0x48/0x64
> May 11 01:01:46 localhost kernel:  [<c17941f6>]
> bus_for_each_dev+0x42/0x6c
> May 11 01:01:46 localhost kernel:  [<c179473f>]
> driver_attach+0x1e/0x20
> May 11 01:01:46 localhost kernel:  [<c179497c>] ?
> driver_probe_device+0x46/0x46
> May 11 01:01:46 localhost kernel:  [<c1793c0b>]
> bus_add_driver+0xc6/0x20a
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c1794eef>]
> driver_register+0x98/0xf8
> May 11 01:01:46 localhost kernel:  [<c1794eef>] ?
> driver_register+0x98/0xf8
> May 11 01:01:46 localhost kernel:  [<c1695525>] ?
> tty_register_driver+0x15e/0x1e2
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c1595541>]
> __pci_register_driver+0x3d/0x96
> May 11 01:01:46 localhost kernel:  [<c1ec9c37>] ?
> printk+0x1d/0x1f
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c24ba7de>]
> sdhci_drv_init+0x14/0x16
> May 11 01:01:46 localhost kernel:  [<c1001174>]
> do_one_initcall+0x8c/0x142
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c1082dfc>] ?
> irq_to_desc+0x8/0x1e
> May 11 01:01:46 localhost kernel:  [<c24ba7ca>] ?
> sdhci_drv_init+0x22/0x22
> May 11 01:01:46 localhost kernel:  [<c245b1fd>] ?
> parse_early_options+0x25/0x25
> May 11 01:01:46 localhost kernel:  [<c245b293>]
> kernel_init+0x96/0x12a
> May 11 01:01:46 localhost kernel:  [<c1ecd4c6>]
> kernel_thread_helper+0x6/0x10
> May 11 01:01:46 localhost kernel: ---[ end trace
> acbbad639e5c6e5c ]---
> May 11 01:01:46 localhost kernel: create_regulator: dummy:
> could not add regulator_dev requested microamps sysfs
> entry
> ---
> Professional hosting for everyone - http://www.host.ru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
