Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab1KUVqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:46:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50245 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab1KUVqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:46:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.2-rc2+: Reported regressions from 3.0 and 3.1
Date: Mon, 21 Nov 2011 22:49:30 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
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
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
In-Reply-To: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111212249.31196.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 3.0 and 3.1
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 3.0 and 3.1, please let us
know either and we'll add them to the list.  Also, please let us know if any of
the entries below are invalid.

The entries below are simplified and the statistics are not present due to the
continuing Bugzilla outage.

Subject    : iwlagn is getting very shaky
Submitter  : Norbert Preining <preining@logic.at>
Date       : 2011-10-19 6:01
Message-ID : 20111019060108.GA11588@gamma.logic.tuwien.ac.at
References : http://marc.info/?l=linux-kernel&m=131914553920614&w=2

Subject    : Regression: "irqpoll" hasn't been working for me since March 16 IRQ
Submitter  : Edward Donovan <edward.donovan@numble.net>
Date       : 2011-10-19 22:09
Message-ID : CADdbW+HXdCPfJu2RTF6zz+ujCmiu_dmZwL2iScuF53p=AaZ1Uw@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=131914554220679&w=2

Subject    : Regression in 3.1 causes Xen to use wrong idle routine
Submitter  : Stefan Bader <stefan.bader@canonical.com>
Date       : 2011-10-26 10:24
Message-ID : 4EA7DFD1.9060608@canonical.com
References : http://marc.info/?l=linux-acpi&m=131962467924564&w=2

Subject    : 3.1+ iwlwifi lockup
Submitter  : Dave Jones <davej@redhat.com>
Date       : 2011-10-31 14:34
Message-ID : 20111031143408.GA17152@redhat.com
References : http://marc.info/?l=linux-kernel&m=132007169420160&w=2

Subject    : hugetlb oops on 3.1.0-rc8-devel
Submitter  : Andy Lutomirski <luto@amacapital.net>
Date       : 2011-11-01 22:20
Message-ID : CALCETrW1mpVCz2tO5roaz1r6vnno+srHR-dHA6_pkRi2qiCfdw@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132018604426692&w=2

Subject    : Simultaneous cat and external keyboard input causing kernel panic
Submitter  : Timo Jyrinki <timo.jyrinki@gmail.com>
Date       : 2011-11-03 12:14
Message-ID : CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132032253903074&w=2

Subject    : Linus GIT - INFO: possible circular locking dependency detected
Submitter  : Miles Lane <miles.lane@gmail.com>
Date       : 2011-11-03 15:57
Message-ID : CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132033587908426&w=2

Subject    : lockdep warning after aa6afca5bcab: "proc: fix races against execve() of /proc/PID/fd**"
Submitter  : Ari Savolainen <ari.m.savolainen@gmail.com>
Date       : 2011-11-08 3:47
Message-ID : CAEbykaXYZEFhTgWMm2AfaWQ2SaXYuO_ypTnw+6AVWScOYSCuuw@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132072413125099&w=2

Subject    : DMA-API check_sync errors with 3.2
Submitter  : Josh Boyer <jwboyer@redhat.com>
Date       : 2011-11-08 17:31
Message-ID : 20111108173153.GE14216@zod.bos.redhat.com
References : http://marc.info/?l=linux-kernel&m=132077357608797&w=2

Subject    : [3.1-rc8 REGRESSION] sky2 hangs machine on turning off or suspending
Submitter  : Rafał Miłecki <zajec5@gmail.com>
Date       : 2011-11-09 11:46
Message-ID : CACna6ryTdLcWVYgHu=_mRFga1sFivpE_DyZOY-HMmKggkWAJAw@mail.gmail.com
References : http://marc.info/?l=linux-netdev&m=132083922228088&w=4

Subject    : 3.2-rc1 doesn't boot on dual socket opteron without swap
Submitter  : Niklas Schnelle <niklas@komani.de>
Date       : 2011-11-10 20:09
Message-ID : 1320955769.1718.8.camel@jupiter
References : http://marc.info/?l=linux-kernel&m=132095583501767&w=2

Subject    : Sparc-32 doesn't work in 3.1.
Submitter  : Rob Landley <rob@landley.net>
Date       : 2011-11-12 11:22
Message-ID : 4EBEAB5A.5020809@landley.net
References : http://www.spinics.net/lists/kernel/msg1260383.html

Subject    : khugepaged blocks suspend2ram (3.2.0-rc1-00252-g8f042aa)
Submitter  : Sergei Trofimovich <slyich@gmail.com>
Date       : 2011-11-12 10:48
Message-ID : 20111112104859.7744b282@sf.home
References : https://lkml.org/lkml/2011/11/12/11

Subject    : WARNING: at fs/sysfs/sysfs.h:195 (during boot)
Submitter  : Markus Trippelsdorf <markus@trippelsdorf.de>
Date       : 2011-11-13 19:24
Message-ID : 20111113192417.GA1659@x4.trippels.de
References : http://marc.info/?l=linux-kernel&m=132121231921932&w=2

Subject    : PROBLEM: Radeon display connector : No monitor connected or invalid EDID
Submitter  : Treeve Jelbert <treeve@scarlet.be>
Date       : 2011-11-13 17:27
Message-ID : 2407026.akcTO2Ggic@gemini-64
References : http://marc.info/?l=linux-kernel&m=132120530920139&w=2

Subject    : [3.1 REGRESSION] Commit 5cec93c216db77c45f7ce970d46283bcb1933884 breaks the Chromium seccomp sandbox
Submitter  : Nix <nix@esperi.org.uk>
Date       : 2011-11-14 0:40
Message-ID : 8762inleno.fsf@spindle.srvr.nix
References : http://marc.info/?l=linux-kernel&m=132123396226377&w=2

Subject    : max PWM is zero
Submitter  : Marcos Paulo de Souza <marcos.mage@gmail.com>
Date       : 2011-11-15 15:14
Message-ID : alpine.LNX.2.00.1111151301410.2693@darkstar.example.net
References : http://marc.info/?l=linux-kernel&m=132137019330548&w=2

Subject    : Oops on suspend with libertas SDIO (Linux 3.2-rc2)
Submitter  : Sven Neumann <s.neumann@raumfeld.com>
Date       : 2011-11-17 15:36
Message-ID : 1321544210.31090.6.camel@sven
References : http://marc.info/?l=linux-kernel&m=132154527715807&w=2

Subject    : Impossible high cpu-time values for migration threads
Submitter  : Markus Trippelsdorf <markus@trippelsdorf.de>
Date       : 2011-11-17 22:17
Message-ID : 20111117221731.GA9229@x4.trippels.de
References : http://marc.info/?l=linux-kernel&m=132156832124314&w=2

Subject    : WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Submitter  : Markus Trippelsdorf <markus@trippelsdorf.de>
Date       : 2011-11-18 7:25
Message-ID : 20111118072519.GA1615@x4.trippels.de
References : http://marc.info/?l=linux-kernel&m=132160119031794&w=2

Subject    : [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth: Increase HCI reset timeout ...)
Submitter  : Tomáš Janoušek <tomi@nomi.cz>
Date       : 2011-11-18 18:40
Message-ID : 20111118184017.GA5052@nomi.cz
References : http://marc.info/?l=linux-kernel&m=132164169511416&w=2

Subject    : [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series
Submitter  : "Nicolas Kalkhof" <nkalkhof@web.de>
Date       : 2011-11-18 20:33
Message-ID : 506786689.810044.1321648395265.JavaMail.fmail@mwmweb010
References : http://marc.info/?l=linux-kernel&m=132164909313594&w=2

Thanks!
