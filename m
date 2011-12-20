Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1LTXvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:51:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1LTXvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:51:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
Date: Wed, 21 Dec 2011 00:54:46 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112210054.46995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Evidently, vger has blocked the previous attempts to post this message
for some reason.  I wonder why?]

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

Subject    : 3.1+ iwlwifi lockup
Submitter  : Dave Jones <davej@redhat.com>
Date       : 2011-10-31 14:34
Message-ID : 20111031143408.GA17152@redhat.com
References : http://marc.info/?l=linux-kernel&m=132007169420160&w=2

Subject    : Linus GIT - INFO: possible circular locking dependency detected
Submitter  : Miles Lane <miles.lane@gmail.com>
Date       : 2011-11-03 15:57
Message-ID : CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132033587908426&w=2

Subject    : DMA-API check_sync errors with 3.2
Submitter  : Josh Boyer <jwboyer@redhat.com>
Date       : 2011-11-08 17:31
Message-ID : 20111108173153.GE14216@zod.bos.redhat.com
References : http://marc.info/?l=linux-kernel&m=132077357608797&w=2

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

Subject    : WARNING: at fs/sysfs/sysfs.h:195 (during boot)
Submitter  : Markus Trippelsdorf <markus@trippelsdorf.de>
Date       : 2011-11-13 19:24
Message-ID : 20111113192417.GA1659@x4.trippels.de
References : http://marc.info/?l=linux-kernel&m=132121231921932&w=2

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

Subject    : Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
Submitter  : Meelis Roos <mroos@linux.ee>
Date       : 2011-11-22 10:15
Message-ID : alpine.SOC.1.00.1111221207090.6490@math.ut.ee
References : http://marc.info/?l=linux-kernel&m=132195700023709&w=2

Subject    : 3.2-rc2 regression: floppy driver breaks boot
Submitter  : Pavel Machek <pavel@ucw.cz>
Date       : 2011-11-22 11:14
Message-ID : 20111122111405.GA28215@elf.ucw.cz
References : http://marc.info/?l=linux-kernel&m=132196052124801&w=2

Subject    : [regression 3.1.0 -> 3.20rc] USB Oops
Submitter  : Norbert Preining <preining@logic.at>
Date       : 2011-11-22 12:52
Message-ID : 20111122125256.GB32440@gamma.logic.tuwien.ac.at
References : http://marc.info/?l=linux-kernel&m=132196644726900&w=2

Subject    : Freezing of tasks failed after 20.01 seconds in kernel 3.2.0-rc2
Submitter  : Belisko Marek <marek.belisko@gmail.com>
Date       : 2011-11-22 21:20
Message-ID : 
CAAfyv36nxYq1EA2pcHi5WR1BdWYHp2sQTY1mMA4Q3JjcOG5RDw@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132199691706100&w=2

Subject    : 3.2.0-rc2+git: possible recursive locking detected in process 
memory freeing
Submitter  : Meelis Roos <mroos@linux.ee>
Date       : 2011-11-23 13:12
Message-ID : alpine.SOC.1.00.1111231311490.15939@math.ut.ee
References : http://lkml.org/lkml/2011/11/23/159

Subject    : i915: 3.2 rc1/2 KMS regression
Submitter  : Patrik Kullman <patrik.kullman@gmail.com>
Date       : 2011-11-23 23:43
Message-ID : CAGPN=9THOv-
M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=132209186403288&w=2

Subject    : 3.2-rc2: regression after hibernate: lots of warnings, broken 
system
Submitter  : Pavel Machek <pavel@ucw.cz>
Date       : 2011-11-24 15:40
Message-ID : 20111124154014.GA2153@elf.ucw.cz
References : http://marc.info/?l=linux-kernel&m=132214929818015&w=2

Subject    : [regression] WARNING: at drivers/block/floppy.c:2929 
do_fd_request+0xb7/0xb9() in 3.2.0-rc2 and 3
Submitter  : Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Date       : 2011-11-25 10:34
Message-ID : 20111125103420.GO4581@charite.de
References : http://marc.info/?l=linux-kernel&m=132221799501685&w=2

Subject    : [BUG] 3.2-rcX radeon KMS system freeze
Submitter  : Bob Tracy <rct@gherkin.frus.com>
Date       : 2011-11-25 20:33
Message-ID : 20111125203351.GA3651@gherkin.frus.com
References : http://marc.info/?l=linux-kernel&m=132225331312019&w=2

Subject    : 3.2-rc2 regression due to commit "USB: EHCI: fix HUB TT scheduling 
issue with iso transfer" 811c926c538f7e8d3c08b630dd5844efd7e000f6
Submitter  : Sander Eikelenboom <linux@eikelenboom.it>
Date       : 2011-11-26 15:47
Message-ID : 1001209018.20111126164712@eikelenboom.it
References : http://marc.info/?l=linux-kernel&m=132232295425393&w=2

Subject    : 3.2-rc3+: [drm:i915_hangcheck_elapsed] ERROR Hangcheck timer 
elapsed... GPU hung
Submitter  : Sergei Trofimovich <slyich@gmail.com>
Date       : 2011-12-02 17:56
Message-ID : 20111202205601.115522b1@sf.home
References : http://marc.info/?l=linux-kernel&m=132284845705156&w=2

Subject    : [BUG] deadlock: jfs (3.2.0-rc4-00154-g8e8da02)
Submitter  : Nico Schottelius <nico-linux-20111201@schottelius.org>
Date       : 2011-12-06 10:05
Message-ID : 20111206100533.GB6161@schottelius.org
References : http://marc.info/?l=linux-kernel&m=132317917827825&w=2

Subject    : [3.2-rc4] pcnet32: DMA-API: device driver tries to sync DMA 
memory it has not allocated
Submitter  : Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date       : 2011-12-09 3:40
Message-ID : 201112090340.pB93ek9i086855@www262.sakura.ne.jp
References : http://marc.info/?l=linux-kernel&m=132340215706219&w=2

Subject    : Enabling FCoE point-to-point mode triggers a deadlock
Submitter  : Bart Van Assche <bvanassche@acm.org>
Date       : 2011-12-09 14:33
References : http://permalink.gmane.org/gmane.linux.scsi.open-fcoe.devel/11451

Subject    : iwlagn unusable in 3.2.0rc4
Submitter  : Dave Jones <davej@redhat.com>
Date       : 2011-12-09 19:42
Message-ID : 20111209194208.GA15236@redhat.com
References : http://marc.info/?l=linux-kernel&m=132345984724433&w=2

Subject    : DRM nouveau crash with 3.2.0-rc5
Submitter  : "Berck E. Nash" <flyboy@gmail.com>
Date       : 2011-12-10 5:10
Message-ID : 4EE2E9BB.8060801@gmail.com
References : http://marc.info/?l=linux-kernel&m=132349393700419&w=2

Subject    : Reiserfs.c bug in 3.2-rc5
Submitter  : "Jorge Bastos" <mysql.jorge@decimal.pt>
Date       : 2011-12-10 23:48
Message-ID : 43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt
References : http://marc.info/?l=linux-kernel&m=132356156914296&w=2

Subject    : [REGRESSION] 3.2.0-rc3 Bluetooth L2CAP Linux to Linux rfcomm 
fails
Submitter  : David Fries <david@fries.net>
Date       : 2011-12-11 5:16
Message-ID : 20111211051624.GA12050@spacedout.fries.net
References : http://marc.info/?l=linux-kernel&m=132358071417198&w=2

Subject    : recent regression: after resume the mouse and X is extremely slow
Submitter  : Norbert Preining <preining@logic.at>
Date       : 2011-12-11 22:13
Message-ID : 20111211221303.GA8710@gamma.logic.tuwien.ac.at
References : http://marc.info/?l=linux-kernel&m=132364169929740&w=2


Thanks!
