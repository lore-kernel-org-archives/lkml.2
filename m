Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1BUV7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:59:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1BUV7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:59:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc5-git6: Reported regressions from 2.6.37
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera>
Date: Mon, 21 Feb 2011 22:52:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.37,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.37, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-02-21       51       18          17
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29402
Subject		: kernel panics while running ffsb scalability workloads on 2.6.38-rc1 through -rc5
Submitter	: Eric Whitney <eric.whitney@hp.com>
Date		: 2011-02-18 21:47 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29322
Subject		: System lockup with 2.6.38-rc4+
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2011-02-14 17:31 (8 days old)
Message-ID	: <201102141731.29331.chris2553@googlemail.com>
References	: http://marc.info/?l=linux-kernel&m=129770471724602&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29252
Subject		: IPv6 doesn't work in a kvm guest.
Submitter	: Kusanagi Kouichi <slash@ac.auone-net.jp>
Date		: 2011-02-16 13:03 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29232
Subject		: [VT-d] VT-d device passthrough fail to guest
Submitter	: xudong <xudong.hao@intel.com>
Date		: 2011-02-16 08:56 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29202
Subject		: 2.6.38-rc: fuse BUG, maybe related to detaching external usb drive without umounting
Submitter	: Florian Mickler <florian@mickler.org>
Date		: 2011-02-15 22:05 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29022
Subject		: [REGRESSION? 2.6.38-rc4] nouveau NV50 screen freeze
Submitter	: Marc <marc@osknowledge.org>
Date		: 2011-02-13 12:29 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28882
Subject		: Screen corruption and GPU hangs
Submitter	: Ko Mi <chaostya.test@hotmail.com>
Date		: 2011-02-11 18:17 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2011-02-08 9:41 (14 days old)
Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28642
Subject		: ACPI broken on DELL Latitude E6410 in 2.6.38-rc3
Submitter	: Adam Kovari <kovariadam@gmail.com>
Date		: 2011-02-08 22:22 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
Subject		: [BUG] usb problems in .38-rc3+
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2011-02-05 19:17 (17 days old)
Message-ID	: <201102051417.58953.edt@aei.ca>
References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (21 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28432
Subject		: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Submitter	: Jindřich Makovička <makovick@gmail.com>
Date		: 2011-01-31 19:28 (22 days old)
Message-ID	: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129650210516627&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (22 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28262
Subject		: Slow resume from suspend/hibernate on Dell Inspiron M301Z
Submitter	: Luca Ferretti <lferrett@gnome.org>
Date		: 2011-02-05 12:37 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Date		: 2011-01-28 20:29 (25 days old)
Message-ID	: <20110128202905.GB3395@schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27022
Subject		: [REPORT] BUG: spinlock recursion on CPU#0, init/1
Submitter	: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date		: 2011-01-10 15:33 (43 days old)
Message-ID	: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129467294808655&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27382
Subject		: ath5k phy0: gain calibration timeout
Submitter	: Nicolas Stransky <Nico@stransky.cx>
Date		: 2011-01-23 00:18 (30 days old)
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
Patch		: https://patchwork.kernel.org/patch/530811/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.37,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

