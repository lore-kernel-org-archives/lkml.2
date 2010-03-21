Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0CUU27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:28:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CUU24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:28:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.34-rc2: Reported regressions from 2.6.33
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
Date: Sun, 21 Mar 2010 20:58:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTES:
 * In this cycle the regressions reported by e-mail will only be put into the
   Bugzilla 1 week after they have been submitted, if not fixed in the
   meantime.  The reason is that some regressions are fixed in less than a
   week time and there's no point listing them.  [We also hope that people will 
   try to fix bugs faster to avoid being listed. ;-)]  If that works, we'll
   adopt it as a general rule.

 * All of the regressions reported by e-mail that are listed below have been
   put into the Bugzilla by Maciej, because I literally didn't have the time
   to do that (that's also why the summary reports are delayed).
   Thanks Maciej!]

This message contains a list of some regressions from 2.6.33,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.33, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-03-21       15       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15590
Subject		: 2.6.34-rc1: regression: ^Z no longer stops sound
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-03-14 7:58 (8 days old)
Message-ID	: <20100314075831.GA13457@elf.ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=126855353122623&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2010-03-13 23:53 (9 days old)
Message-ID	: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15584
Subject		: 2.6.34-rc1: lockdep warning on geode subnotebook
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-03-13 10:51 (9 days old)
Message-ID	: <20100313105109.GA9966@elf.ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=126847750927601&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15555
Subject		: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
Submitter	: Américo Wang <xiyou.wangcong@gmail.com>
Date		: 2010-03-10 8:29 (12 days old)
Message-ID	: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126820979017089&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15549
Subject		: [2.6.34-rc1][libata] regression?
Submitter	: Etienne Basset <etienne.basset@numericable.fr>
Date		: 2010-03-09 21:47 (13 days old)
Message-ID	: <4B96C202.6050606@numericable.fr>
References	: http://marc.info/?l=linux-kernel&m=126817180811846&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15548
Subject		: BUG: key f70f4b50 not in .data
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-03-09 10:27 (13 days old)
Message-ID	: <20100309102754.GA3316@swordfish.minsk.epam.com>
References	: http://marc.info/?l=linux-kernel&m=126813046113130&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15533
Subject		: i915 fails to set mode in 2.6.34-rc1, ok in 2.6.33-rc8
Submitter	: Pete Zaitcev <zaitcev@yahoo.com>
Date		: 2010-03-13 20:37 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15518
Subject		: CONFIG_NO_BOOTMEM=y breaks boot on 32bit
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2010-03-11 15:37 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15496
Subject		: 2.6.34-rc1 crashes early while startup
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-03-09 19:40 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15495
Subject		: Flood of SELinux denials on polkitd
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2010-03-09 16:47 (13 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15537
Subject		: 2.6.34-rc1 hangs for 30 seconds when trying to access the disk
Submitter	: Andrew Benton <b3nton@gmail.com>
Date		: 2010-03-14 23:26 (8 days old)
Handled-By	: Jeff Garzik <jgarzik@pobox.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=25516


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15505
Subject		: No more b43 wireless interface since 2.6.34-rc1
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-03-10 06:59 (12 days old)
Handled-By	: Yinghai Lu <yinghai@kernel.org>
Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=15505#c11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15480
Subject		: [regression] Fails to boot properly unless given pci=nocrs
Submitter	: Yanko Kaneti <yaneti@declera.com>
Date		: 2010-03-09 01:24 (13 days old)
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2010/3/11/512


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.33,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=15310

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

