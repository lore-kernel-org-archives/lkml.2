Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2DCHax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:30:53 -0400
Received: from trent.utfs.org ([94.185.90.103]:54728 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab2DCHaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:30:52 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2012 03:30:52 EDT
Date: Tue, 3 Apr 2012 00:20:24 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: linuxppc-dev@lists.ozlabs.org
cc: LKML <linux-kernel@vger.kernel.org>
Subject: 3.4.0-rc1: No init found
Message-ID: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going from 3.3-rc7 to 3.4-rc1 (with "make oldconfig" inbetween) did not 
go well on this PowerBook G4 machine:

Apr  2 15:18:23 [   8.318816] EXT4-fs (hda6): mounted filesystem with ordered data mode. Opts: (null)
Apr  2 15:18:23 [   8.320286] VFS: Mounted root (ext4 filesystem) readonly on device 3:6.
Apr  2 15:18:23 [   8.341555] devtmpfs: mounted
Apr  2 15:18:23 [   8.343384] Freeing unused kernel memory: 204k freed
Apr  2 15:18:23 [   8.457056] Kernel panic - not syncing: No init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
Apr  2 15:18:23 [   8.459936] Rebooting in 180 seconds..

No bootoptions were changed, no disks swapped, no partitions altered 
whatsoever. Full .config & dmesg:

 http://nerdbynature.de/bits/3.4.0-rc1/init/

Thanks,
Christian.

PS: Unfortunately I cannot boot into the old (3.3-rc7) kernel 
    right now (which is still installed via "yaboot" and present in
    /boot), because of this: 
    http://nerdbynature.de/bits/3.4.0-rc1/init/mac-invalid-memory.JPG
    Booting into Debian's "squeeze" kernel (2.6.32) which resides in
    the same /boot directory succeeds.
-- 
BOFH excuse #334:

50% of the manual is in .pdf readme files
