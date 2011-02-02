Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1BBXC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:02:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1BBXC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:02:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc3-git1: Reported regressions from 2.6.37
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
Message-ID: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
Date: Thu,  3 Feb 2011 00:02:08 +0100 (CET)
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
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Date		: 2011-01-28 20:29 (6 days old)
Message-ID	: <20110128202905.GB3395@schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28052
Subject		: [BUG] 2.6.38-rc2: Circular Locking Dependency
Submitter	: Knut Petersen <Knut_Petersen@t-online.de>
Date		: 2011-01-24 9:25 (10 days old)
Message-ID	: <4D3D45A3.7040809@t-online.de>
References	: http://marc.info/?l=linux-kernel&m=129586118515443&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27812
Subject		: 2.6.38-rc2: acpi backlight control missing
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2011-01-22 10:49 (12 days old)
First-Bad-Commit: http://git.kernel.org/linus/677bd810eedce61edf15452491781ff046b92edc
Message-ID	: <1295693349.2120.3.camel@localhost.localdomain>
References	: http://marc.info/?l=linux-kernel&m=129569353414755&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27652
Subject		: 38-rc1: umount+rmmod cause ext4 error.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-19 6:53 (15 days old)
Message-ID	: <4D368A70.5030103@tao.ma>
References	: http://marc.info/?l=linux-ext4&m=129542001031750&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27382
Subject		: ath5k phy0: gain calibration timeout
Submitter	: Nicolas Stransky <Nico@stransky.cx>
Date		: 2011-01-23 00:18 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27282
Subject		: Regression: 2.6.38 vs. Powertop 2
Submitter	: Dennis Jansen <dennis.jansen@web.de>
Date		: 2011-01-21 14:34 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27022
Subject		: [REPORT] BUG: spinlock recursion on CPU#0, init/1
Submitter	: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date		: 2011-01-10 15:33 (24 days old)
Message-ID	: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129467294808655&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28012
Subject		: [drm:i915_driver_load] *ERROR* failed to init modeset, EINVAL
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2011-02-01 15:18 (2 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=45892


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27862
Subject		: Cannot launch X.org server on Core I5 with 2.6.38-rc2-git7
Submitter	: Darisuz Luksza <dariusz.luksza@gmail.com>
Date		: 2011-01-30 12:13 (4 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: https://bugs.freedesktop.org/attachment.cgi?id=42634


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27702
Subject		: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight cannot be adjusted
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2011-01-21 1:55 (13 days old)
Message-ID	: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=129557717826819&w=2
Handled-By	: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Patch		: https://patchwork.kernel.org/patch/499221/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27472
Subject		: 5bd5a45 breaks resume from suspend on Thinkpad X201
Submitter	: Björn Schließmann <chronoss@gmx.de>
Date		: 2011-01-23 23:24 (11 days old)
Handled-By	: CASTET Matthieu <castet.matthieu@free.fr>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=45192


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.37,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

