Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1FLUlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 16:41:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1FLUl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 16:41:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.0-rc2: Reported regressions from 2.6.39
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
Message-ID: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>
Date: Sun, 12 Jun 2011 22:23:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.39,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.39, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-06-12        8        7           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37242
Subject		: lockdep deadlock warning in shutdown
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2011-06-03 3:24 (10 days old)
Message-ID	: <1307071472.15392.60.camel@sli10-conroe>
References	: http://marc.info/?l=linux-acpi&m=130707148811930&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37232
Subject		: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-06-03 4:56 (10 days old)
Message-ID	: <4478124.OuFNgaPiHS@segfault.sh0n.net>
References	: http://marc.info/?l=linux-kernel&m=130707737616116&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37222
Subject		: 3.0.0-rc1-git3 -- kernel/sched.c:619 invoked rcu_dereference_check() without protection!
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2011-06-04 3:22 (9 days old)
Message-ID	: <BANLkTikHS7TuFhm3cfJ+Y=erWDaAwuE_TA@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=130715775803343&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36982
Subject		: 3.0-rc1 problem with usb, cdrom
Submitter	: werner <w.landgraf@ru.ru>
Date		: 2011-06-01 16:43 (12 days old)
Message-ID	: <web-538043386@zbackend1.aha.ru>
References	: http://marc.info/?l=linux-kernel&m=130694663410114&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36972
Subject		: 3.0-rc1: DMAR errors from iwlagn
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2011-05-31 21:14 (13 days old)
Message-ID	: <4DE55A26.6040702@goop.org>
References	: http://marc.info/?l=linux-kernel&m=130687723213857&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36452
Subject		: Artifacts with 3.0-rc1 on SandyBridge
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2011-06-01 13:55 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36302
Subject		: SandyBridge can't do s2disk with linux 3.0-rc1
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2011-05-30 23:10 (14 days old)


Regressions with patches
------------------------

For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.39,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=36912

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

