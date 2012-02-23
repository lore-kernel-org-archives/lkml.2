Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2BWXIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:08:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2BWXIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:08:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.3-rc4+: Reported regressions from 3.2
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
Message-ID: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
Date: Thu, 23 Feb 2012 23:51:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We definitely aren't 100% in business yet with the tracking of regressions,
but since the Bugzilla is operational again, we can collect reports at least.

I'd like to use this opportunity to thank Maciej Rutecki and Florian Mickler
for their hard work on the regression tracking and to clarify some things that
seem to have caused some confusion to happen recently.  Namely, we use the
kernel Bugzilla (https://bugzilla.kernel.org) for the tracking of regressions
for the simple reason that our scripts generate the lists that are posted
(like the one below) out of Bugzilla entries created by us (and sometimes
by other people).  Those entries are used by us as a storage of information,
so we're going to add them even though some kernel developers don't seem to
like that.  We don't require developers to actually use those entries for
handling bug reports, we only need people to let us know when they should be
closed, because the bug has been fixed in the Linus' tree, or when there's
a patch available for the bug (in which case we mark it as "resolved", but
we don't close it just yet).  There is no reason for you to be openly hostile
to Maciej, who's been creating those entries recently, because he's just been
doing his job.  However, you may not want us to track kernel regressions at
all, in which case please let us know about that and we will find some other,
presumably equally interesting things to do. :-)

Yes, we might have been more verbose about what _exactly_ we've been using the
Bugzilla for and what our workflow is, but at the same time people might have
been a bit less harsh to someone who's been doing a service to the community,
completely voluntarily.

Thanks,
Rafael

---

This message contains a list of some regressions from 3.2,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 3.2, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2012-02-23       15       13          13


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42798
Subject		: i915 regression with 3.3-rc3+git
Submitter	: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Date		: 2012-02-17 20:48 (7 days old)
Message-ID	: <4F3EBD0D.7000906@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=132951173002619&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42776
Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2012-02-13 7:45 (11 days old)
Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42761
Subject		: Possible circular locking dependency (3.3-rc2)
Submitter	: Felipe Balbi <balbi@ti.com>
Date		: 2012-02-08 12:41 (16 days old)
Message-ID	: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
References	: http://marc.info/?l=linux-kernel&m=132870492311858&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42746
Subject		: 3.3-rc2 snd_pcm lockdep backtrace
Submitter	: Josh Boyer <jwboyer@redhat.com>
Date		: 2012-02-06 14:56 (18 days old)
Message-ID	: <20120206145621.GA4771@zod.bos.redhat.com>
References	: http://marc.info/?l=linux-kernel&m=132854040916172&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42735
Subject		: kobject (ffff88003ffbb4b8): tried to init an initialized object, something is seriously wrong.
Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date		: 2012-02-03 20:59 (21 days old)
Message-ID	: <20120203205953.GA2897@phenom.dumpdata.com>
References	: http://marc.info/?l=linux-kernel&m=132830315526901&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42734
Subject		: dosemu graphics broken in v3.3-rc1
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2012-02-02 22:25 (22 days old)
First-Bad-Commit: http://git.kernel.org/linus/308e5bcbdb10452e8aba31aa21432fb67ee46d72
Message-ID	: <4F2B0D4D.3000304@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=132825899111982&w=2
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42733
Subject		: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET failed
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2012-02-02 5:12 (22 days old)
Message-ID	: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=132815978615112&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42713
Subject		: Regression in skge that started around acb42a3 (so past v3.3-rc1)
Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date		: 2012-01-30 15:58 (25 days old)
Message-ID	: <20120130155816.GA1400@phenom.dumpdata.com>
References	: http://marc.info/?l=linux-kernel&m=132793944220262&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42707
Subject		: Hang deconfiguring network interface (in shutdown) on 3.3-rc1
Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
Date		: 2012-01-28 19:56 (27 days old)
Message-ID	: <1327780565.2924.24.camel@dabdike.int.hansenpartnership.com>
References	: http://marc.info/?l=linux-kernel&m=132778076214873&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42686
Subject		: iwlagn is getting even worse with 3.3-rc1
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2012-01-24 1:36 (31 days old)
Message-ID	: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=132736918325378&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42683
Subject		: WARN... Device 'cpu1' does not have a release() function, it is broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date		: 2012-01-23 18:06 (32 days old)
Message-ID	: <20120123180601.GA24553@phenom.dumpdata.com>
References	: http://marc.info/?l=linux-kernel&m=132734233916154&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42678
Subject		: [3.3-rc1] radeon stuck in kernel after lockup
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2012-01-21 19:03 (34 days old)
Message-ID	: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=132717279606670&w=2
Handled-By	: Jérôme Glisse <glisse@freedesktop.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42669
Subject		: 3.3-rc1: compiling problems  nvme , l2cap_sock , mc13892-regulator , and snd-pcsp don't work
Submitter	: werner <w.landgraf@ru.ru>
Date		: 2012-01-20 18:52 (35 days old)
Message-ID	: <web-682421181@zbackend1.aha.ru>
References	: http://marc.info/?l=linux-kernel&m=132708923719565&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 3.2,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=42644

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

