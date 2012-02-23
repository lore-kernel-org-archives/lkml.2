Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2BWXWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:22:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2BWXV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:21:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.3-rc4+: Reported regressions 3.1 -> 3.2
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
Message-ID: <1qKPXd1RqtP.A.wjG.ShsRPB@chimera>
Date: Fri, 24 Feb 2012 00:05:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some post-3.1 regressions introduced before
3.2, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-3.1 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2012-02-24        9        8           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42714
Subject		: 3.2.x Regression for SAS Controller on Dell C6100
Submitter	: Herbert Poetzl <herbert@13thfloor.at>
Date		: 2012-01-31 18:09 (24 days old)
Message-ID	: <20120131180949.GT29272@MAIL.13thfloor.at>
References	: http://marc.info/?l=linux-kernel&m=132803360019481&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42685
Subject		: multi-media key "mute" no longer recognized
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2012-01-23 10:52 (32 days old)
Message-ID	: <201201231152.25344.toralf.foerster@gmx.de>
References	: http://marc.info/?l=linux-kernel&m=132731613606121&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42684
Subject		: FYIO: usb/video 3.2 breaks logitech 9000pro webcam focus control
Submitter	: M G Berberich <berberic@fmi.uni-passau.de>
Date		: 2012-01-23 21:49 (32 days old)
Message-ID	: <20120123214934.GA4240@invalid>
References	: http://marc.info/?l=linux-kernel&m=132735609521443&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42631
Subject		: Sound broken in 3.2.0 and 3.2.1
Submitter	: Joseph Parmelee <jparmele@wildbear.com>
Date		: 2012-01-13 19:44 (42 days old)
Message-ID	: <alpine.LNX.2.00.1201131241090.1239@bruno>
References	: http://marc.info/?l=linux-kernel&m=132648462806235&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42629
Subject		: recvmsg sleeping from invalid context
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2012-01-13 18:24 (42 days old)
Message-ID	: <20120113182401.GA25885@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=132647921304184&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42611
Subject		: kernel 3.2 crashes too early on HP dc7700 and HP t5000 series
Submitter	: Dmitry D. Khlebnikov <galaxy@openwall.com>
Date		: 2012-01-10 11:49 (45 days old)
Message-ID	: <20120110114905.GC13535@openwall.com>
References	: http://marc.info/?l=linux-kernel&m=132619793012702&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42610
Subject		: 3.2.0 reboot powers off machine
Submitter	: Tom Weber <l_linux-kernel@mail2news.4t2.com>
Date		: 2012-01-11 11:03 (44 days old)
Message-ID	: <1326279818.24835.12.camel@utumno>
References	: http://marc.info/?l=linux-kernel&m=132628059308023&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42571
Subject		: BUG in ofcs2_change_file_space
Submitter	: Bret Towe <magnade@gmail.com>
Date		: 2012-01-05 22:23 (50 days old)
Message-ID	: <CALjC5haTNDMOTDPL1m1uBTc2a-Qb8cvR44SCaVDFMzGc+Gw3+w@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=132580236211209&w=2
Patch		: http://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008464.html


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 3.1 and 3.2, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=42566

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

