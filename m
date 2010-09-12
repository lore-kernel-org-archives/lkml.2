Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0ILSbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:31:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab0ILSbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:31:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc3-git5: Reported regressions from 2.6.35
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
Message-ID: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
Date: Sun, 12 Sep 2010 20:11:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE:
 Florian Mickler has joined the regression tracking team.  He is going to
 browse the list periodically to close fixed regressions, add patches etc.
 So, when the listed regressions you care about are fixed, please report
 that to Florian.  If there's a working patch for a regression you care
 about, please report that to him too.]

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
  2010-09-12       28       14          13
  2010-08-30       21       16          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17952
Subject		: bdi-default hung waiting for kthread_stop to finish
Submitter	: Jeff Layton <jlayton@redhat.com>
Date		: 2010-09-02 18:55 (11 days old)
Message-ID	: <20100902145509.28e4f998@tlielax.poochiereds.net>
References	: http://marc.info/?l=linux-kernel&m=128345371904504&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17752
Subject		: 2.6.36-rc3: inconsistent lock state (iprune_sem, shrink_icache_memory)
Submitter	: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date		: 2010-09-01 6:37 (12 days old)
Message-ID	: <tkrat.ed8eda6bc8ffe64e@s5r6.in-berlin.de>
References	: http://marc.info/?l=linux-kernel&m=128332308528119&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17722
Subject		: 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-08-31 20:14 (13 days old)
Message-ID	: <201008312214.52473.thomas@m3y3r.de>
References	: http://marc.info/?l=linux-kernel&m=128328580504227&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17361
Subject		: Watchdog detected hard LOCKUP in jbd2_journal_get_write_access
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-08-29 19:59 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17341
Subject		: kdump regression compared to v2.6.35
Submitter	: CAI Qian <caiqian@redhat.com>
Date		: 2010-08-27 12:35 (17 days old)
Message-ID	: <2136707099.1405541282912500148.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References	: http://marc.info/?l=linux-kernel&m=128291252612135&w=2
Handled-By	: Tejun Heo <tj@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17331
Subject		: BUG: scheduling while atomic
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-08-27 7:59 (17 days old)
Message-ID	: <20100827075911.GA5966@swordfish.minsk.epam.com>
References	: http://marc.info/?l=linux-kernel&m=128289602925505&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17321
Subject		: i386 WARNING: at kernel/softirq.c:143 _local_bh_enable_ip+0x2f/0x7e
Submitter	: Arno Schuring <aelschuring@hotmail.com>
Date		: 2010-08-27 20:04 (17 days old)
Message-ID	: <4C781A3A.4010707@hotmail.com>
References	: http://marc.info/?l=linux-kernel&m=128294076822387&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17311
Subject		: 2.6.36-rc2-git4 - INFO: possible circular locking dependency detected
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-08-27 1:56 (17 days old)
First-Bad-Commit: http://git.kernel.org/linus/5a652052fedbd7869572c757dd2ffc2ed420c69d
Message-ID	: <AANLkTinHbEW36D5R9NSrGgfbOC0Hri3Tg-fA0iR92Udi@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128287422106267&w=2
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17131
Subject		: WARN with 3c905 boomerang NIC
Submitter	: Doug Nazar <nazard.lkml@gmail.com>
Date		: 2010-08-22 6:35 (22 days old)
Message-ID	: <4C70C516.5020404@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128245894300623&w=2
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17061
Subject		: 2.6.36-rc1 on zaurus: bluetooth regression
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-08-21 15:24 (23 days old)
Message-ID	: <20100821152445.GA1536@ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=128240433828087&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2010-08-19 21:03 (25 days old)
Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16961
Subject		: kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-08-19 9:54 (25 days old)
Message-ID	: <<20100819095429.GA5201@swordfish.minsk.epam.com>>
References	: http://marc.info/?l=linux-kernel&m=128221169606214&w=2
Handled-By	: Avi Kivity <avi@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16951
Subject		: hackbench regression with 2.6.36-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2010-08-18 6:18 (26 days old)
Message-ID	: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=128211235904910&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17742
Subject		: 2.6.36-rc2-git5: Oops in snd_pcm_substream_proc_status_read()
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2010-09-01 8:19 (12 days old)
Message-ID	: <20100901041924.23a8a865@katamari>
References	: http://marc.info/?l=linux-kernel&m=128332930703451&w=2
		  https://bugzilla.redhat.com/show_bug.cgi?id=628404
		  https://bugzilla.redhat.com/show_bug.cgi?id=628404#c5
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: http://mailman.alsa-project.org/pipermail/alsa-devel/2010-September/031275.html


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.35,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=16444

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

