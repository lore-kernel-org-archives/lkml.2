Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1H1TEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:04:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1H1TEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:04:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.1-rc3-git6: Reported regressions from 3.0
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
Message-ID: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
Date: Sun, 28 Aug 2011 20:22:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 3.0,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 3.0, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-08-28        8        4           4


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41742
Subject		: duplicate filename  for intel_backlight with the i915 driver
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2011-08-25 18:51 (4 days old)
First-Bad-Commit: http://git.kernel.org/linus/aaa6fd2a004147bf32fce05720938236de3361d9


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41512
Subject		: 3.1-rc2 failed s2ram: Freezing of tasks failed after 20.00 seconds
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2011-08-16 9:42 (13 days old)
Message-ID	: <20110816094245.GA2042@Pilar.site>
References	: http://marc.info/?l=linux-kernel&m=131348782017435&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41502
Subject		: cfq-iosched: a regression
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2011-08-16 2:47 (13 days old)
Message-ID	: <1313462826.27321.22.camel@sli10-conroe>
References	: http://marc.info/?l=linux-kernel&m=131346279329911&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41442
Subject		: rcu_sched_state detected stall on CPU 0, when booting on Xen
Submitter	: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Date		: 2011-08-21 04:06 (8 days old)


Regressions with patches
------------------------

For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 3.0,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=40982

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

