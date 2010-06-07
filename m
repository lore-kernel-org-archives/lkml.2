Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0FGAXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 20:23:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37092 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0FGAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 20:23:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WeFkEW1r1+0rKCNa4HXJLXuLhH6rwf39/qeSGUZ2XmhratDLi/104ovjhAGTTTDS8I
         r4+tD8oYPK3VjtCI/QzXTiIOy4aTi2OOiUsQO3MDCp5rStNeXrG3thO8gBUyoB0PFvoj
         w6PvblJ4ObgS1KkRW20DO7+i2VJestEJU/whQ=
MIME-Version: 1.0
Date: Sun, 6 Jun 2010 20:23:27 -0400
Message-ID: <AANLkTincwMZPnYW3S4uz4k2GOn52RpgBIBRfzyD010Yo@mail.gmail.com>
Subject: [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename 
	'/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
From: Ryan Wang <openspace.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   I have just compiled 2.6.35-rc2 on my VMWare Player box, and
got the warning info after boot up from dmesg.

------------[ cut here ]------------
WARNING: at /home/crossover/kernel-dev/src/linux-2.6.35-rc2/fs/sysfs/dir.c:451
sysfs_add_one+0xa1/0x110()
Hardware name: VMware Virtual Platform
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:11.0/0000:02:02.0/slot'
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W   2.6.35-rc2 #1
Call Trace:
 [<c0444402>] warn_slowpath_common+0x72/0xa0
 [<c054ed81>] ? sysfs_add_one+0xa1/0x110
 [<c054ed81>] ? sysfs_add_one+0xa1/0x110
 [<c04444d3>] warn_slowpath_fmt+0x33/0x40
 [<c054ed81>] sysfs_add_one+0xa1/0x110
 [<c054f415>] sysfs_do_create_link+0xa5/0x150
 [<c054fdc1>] ? sysfs_create_bin_file+0x21/0x30
 [<c054f4f7>] sysfs_create_link+0x17/0x20
 [<c060c976>] pci_create_sysfs_dev_files+0x356/0x4d0
 [<c060b186>] ? pci_get_subsys+0x76/0xa0
 [<c0aa6fc1>] pci_sysfs_init+0x1a/0x44
 [<c0401132>] do_one_initcall+0x32/0x1d0
 [<c0aa6fa7>] ? pci_sysfs_init+0x0/0x44
 [<c0a823b7>] kernel_init+0x13e/0x1d9
 [<c0a82279>] ? kernel_init+0x0/0x1d9
 [<c04035c2>] kernel_thread_helper+0x6/0x10
---[ end trace f545de55182313ba ]---
