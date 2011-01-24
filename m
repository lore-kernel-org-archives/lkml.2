Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AXJrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:47:22 -0500
Received: from nm19-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.113]:24542
	"HELO nm19-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752129Ab1AXJrV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:47:21 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 877637.34971.bm@omp1034.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=vGz72Kz49Tg1PXx6af/W42iv8wA/rwN+Xuj1oSEMDfP7BSR7F+Etx9Khdx1AmCop34Wa/sgYEPYGODJwHbhMbd4+oj5ZEuboR57eI48kOomSVnLMkRci0l0PcDJyfd5sN+moiCrLONrMEcX1U8Xx7bYUjBbHk6+rkA7KOBFh7uo=;
Message-ID: <556624.21214.qm@web28409.mail.ukl.yahoo.com>
X-YMail-OSG: 6tj_0mcVM1l7cGHrn_0B0AQhLBFI9KksCZnKZs5Nme0_g1B
 0dBM.1LpFKEgy6h.iqs7_InO8hVdz9rBuX_0Jx6N09WCAqnm.7lIX2NuXIG5
 _JyVHlzdGHjC5lqnYeC0w2ffIdvb1ZjxAOs_.V.XZumPyPGZ7eATd00MnL9c
 rSz980iULyFsREXEfVJfADLsKKknsMgeR4JdgItMf4SbFTIPBs7G6GV70fpw
 mGrS8QGws.GYTTrLFUdIoIrR2mPswHPPdED4pJ2EAVxxprdsTKYXFwa4ABfj
 u81plJz2sO9Bwvr1ib.XMgSQlvBSq2U1Yinhx0Hz7.MdvDxSpmxV87A--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 24 Jan 2011 09:47:16 +0000 (GMT)
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
To: =?utf-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com
In-Reply-To: <201101241121.50658.ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- En date de : Lun 24.1.11, Ozan Çağlayan <ozan@pardus.org.tr> a écrit :

> De: Ozan Çağlayan <ozan@pardus.org.tr>
> Objet: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
> À: "Lionel Debroux" <lionel_debroux@yahoo.fr>
> Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, rjw@sisk.pl, colin.king@canonical.com
> Date: Lundi 24 janvier 2011, 10h21
> Pazartesi 24 Ocak 2011 günü (saat
> 11:04:35) Lionel Debroux şunları yazmıştı:
> > 
> > --- En date de : Dim 23.1.11, Ozan Çağlayan <ozan@pardus.org.tr>
> > a écrit :
> > 
> > > De: Ozan Çağlayan <ozan@pardus.org.tr>
> > > Objet: Re: Common boot/shutdown issues with the
> latest 2.6.37 (Mostly Asus laptops)
> > > À: linux-acpi@vger.kernel.org,
> linux-kernel@vger.kernel.org,
> platform-driver-x86@vger.kernel.org,
> rjw@sisk.pl, colin.king@canonical.com
> > > Date: Dimanche 23 janvier 2011, 21h24
> > > On 23.01.2011 16:28, Ozan Çağlayan
> > > wrote:
> > > > Hi,
> > > >
> > > > I'm getting a lot of bug reports about
> hanging
> > > boot/shutdowns on these
> > > > days.
> > > >
> > > > Most of the affected hardware are ASUS
> laptops. The
> > > problem is that I
> > > > don't have access to any of those
> problematic laptops
> > > and the users are
> > > > not able at all to debug/bisect what is
> going on.
> > > However, I have
> > > > collected dmesgs of good/bad boots,
> acpidump, etc.
> > > >
> > > > Here are the current status:
> > > >
> > > > "Asus F50SV does not boot unless lapic is
> passed"
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=26502
> > > >
> > > > "Regression between 2.6.35-020635-rc1 and
> > > 2.6.35-020635 breaks acpi
> > > > support on Asus X71 laptop"
> > > > https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/689796
> > > >
> > > > "Asus N61JQ hangs at shutdown unless lapic
> is passed"
> > > > (Not reported upstream yet, I've only
> downstream bug
> > > report which is
> > > > Turkish)
> > > > http://bugs.pardus.org.tr/show_bug.cgi?id=15969
> > > >
> > > > "Asus X61S does not boot unless acpi=off is
> given"
> > > > (Not reported upstream yet, I've only
> downstream bug
> > > report which is
> > > > Turkish)
> > > > http://bugs.pardus.org.tr/show_bug.cgi?id=16322
> > > > (I've told the reporter to try with nolapic,
> it will
> > > probably fix the
> > > > issue but until confirmed acpi=off is the
> only
> > > solution. 2.6.36 was fine)
> > > >
> > > > I'll post more bugs in here as I've found
> them.
> > > 
> > > (CC'ing: Colin King from Canonical)
> > > 
> > > Another one for Asus N90Sc which was booting fine
> with
> > > 10.04
> > > but fails to boot with 10.10:
> > >   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/653626
> > > 
> > > Seen that the issue mostly happens on Asus boxes,
> it's
> > > possible
> > > that their firmwares are buggy but they were
> > > booting/shutting down
> > > correctly until a recent change in kernel.
> > My ASUS F3Jv-AS022P (Core 2 Duo T7200, 2 GB RAM, BIOS
> version
> > 207) has trouble (read: it reboots within one second
> of the
> > vmlinuz being loaded) with recent kernels as well.
> > 
> > While I haven't performed a full bisection yet (which
> is why 
> > I didn't try reporting the problem until I saw this
> thread),
> > I have narrowed down the problem by compiling several
> tagged
> > versions:
> > * 2.6.35 series: .4 and .6 boot successfully, .8 and
> .10 fail;
> > * 2.6.36 series: -rc2 boots successfully, .1 fails;
> > * 2.6.37 series: -rc4 fails.
> 
> So it's probably a commit to the mainline tree which was
> picked by 2.6.35
> maintainer to the stable tree (probably it was CC'ed) cause
> this.
> 
> Does passing nolapic or acpi=off cures the issue?
IIRC, I tested at least one of these, without improvement.
I'll test again tonight, when I can physically access the
computer.

> Maybe rebooting immediately while booting
> is a sign of another problem, I don't know.
>
> ---
> Ozan Çağlayan
> TUBITAK/UEKAE - Pardus Linux
> http://www.pardus.org.tr/eng


Lionel.


      
