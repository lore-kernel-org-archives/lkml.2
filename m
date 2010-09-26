Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0IZUTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:19:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0IZUTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:19:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc5-git7: Reported regressions from 2.6.35
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
Message-ID: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
Date: Sun, 26 Sep 2010 21:55:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.35,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.35, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-09-26       46       15          13
  2010-09-20       38       15          15
  2010-09-12       28       14          13
  2010-08-30       21       16          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19082
Subject		: fs/fs-writeback.c to dump
Submitter	: Pavel Vasilyev <pavel@pavlinux.ru>
Date		: 2010-09-25 15:52 (2 days old)
Message-ID	: <201009251952.58749.pavel@pavlinux.ru>
References	: http://marc.info/?l=linux-kernel&m=128543035026659&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19072
Subject		: [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2010-09-23 17:02 (4 days old)
Message-ID	: <19611.34846.813757.309183@pilspetsen.it.uu.se>
References	: http://marc.info/?l=linux-kernel&m=128526136531048&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19062
Subject		: Dirtiable inode bdi default != sb bdi btrfs
Submitter	: Cesar Eduardo Barros <cesarb@cesarb.net>
Date		: 2010-09-23 0:54 (4 days old)
Message-ID	: <4C9AA546.6050201@cesarb.net>
References	: http://marc.info/?l=linux-kernel&m=128520328929595&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19052
Subject		: 2.6.36-rc5-git1 -- [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-09-22 23:47 (5 days old)
Message-ID	: <AANLkTikWQjUQjFJU9MO1+XbSLAEE-GARz+S+Dz2Fgu4h@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128519926626322&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19002
Subject		: Radeon rv730 AGP/KMS/DRM kernel lockup
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2010-09-23 16:48 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18992
Subject		: warn_slow_path_common in iwlagn/mac80211 in 2.6.36-rc5
Submitter	: rocko <rockorequin@hotmail.com>
Date		: 2010-09-23 03:07 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18342
Subject		: [regression] i915 incorrectly detects bogus LVDS connection instead of LVDS1
Submitter	: Woody Suwalski <terraluna977@gmail.com>
Date		: 2010-09-08 15:10 (19 days old)
Message-ID	: <AANLkTim2mrVRCKg-2couMTFV7krHQp0+2e_cbaiT_KYW@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128395866331382&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17722
Subject		: 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-08-31 20:14 (27 days old)
Message-ID	: <201008312214.52473.thomas@m3y3r.de>
References	: http://marc.info/?l=linux-kernel&m=128328580504227&w=2
		  http://www.spinics.net/lists/netdev/msg140769.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17361
Subject		: Watchdog detected hard LOCKUP in jbd2_journal_get_write_access
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-08-29 19:59 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17121
Subject		: Two blank rectangles more than 10 cm long when booting
Submitter	: Eric Valette <eric.valette@free.fr>
Date		: 2010-08-26 17:24 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17061
Subject		: 2.6.36-rc1 on zaurus: bluetooth regression
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-08-21 15:24 (37 days old)
Message-ID	: <20100821152445.GA1536@ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=128240433828087&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2010-08-19 21:03 (39 days old)
Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16951
Subject		: hackbench regression with 2.6.36-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2010-08-18 6:18 (40 days old)
Message-ID	: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=128211235904910&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18962
Subject		: screen failes in kde
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2010-09-22 15:42 (5 days old)
First-Bad-Commit: http://git.kernel.org/linus/e259befd9013e212648c3bd4f6f1fbf92d0dd51d
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=31042


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18742
Subject		: PROBLEM: Kernel panic on 2.6.36-rc4 when loading intel_ips on Core i3 laptop
Submitter	: infernix <infernix@infernix.net>
Date		: 2010-09-15 14:35 (12 days old)
Message-ID	: <4C90D998.6050103@infernix.net>
References	: http://marc.info/?l=linux-kernel&m=128456187928496&w=2
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=31112


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.35,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=16444

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

