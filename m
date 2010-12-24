Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0LXBps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 20:45:48 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:45965 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0LXBpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 20:45:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, mat <castet.matthieu@free.fr>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
In-Reply-To: Your message of "Thu, 23 Dec 2010 10:01:48 EST."
             <1293116508.22802.14.camel@gandalf.stny.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <4CE2F914.9070106@free.fr> <24422.1290656467@localhost> <20101126182355.62615dff@mat-laptop> <20101208221951.GO5750@outflux.net> <20101211001857.4c5e0794@mat-laptop> <20101222124019.GG10809@elte.hu> <34428.1293053719@localhost>
            <1293116508.22802.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293155030_5070P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Dec 2010 20:43:50 -0500
Message-ID: <63168.1293155030@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4D13FADC.00A9,ss=1,fgs=0,
	ip=98.249.9.36,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293155030_5070P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Dec 2010 10:01:48 EST, Steven Rostedt said:
> On Wed, 2010-12-22 at 16:35 -0500, Valdis.Kletnieks@vt.edu wrote:
> 
> > Steve Rostedt's patch that moves the setting of the page permissions seems to
> > make this patch no longer necessary.  I tripped over this same issue, but the
> > version in the latest -mmotm does not need it, as it includes Steve's fix.
> 
> Can I add your "Tested-by: ..." to the commit?

Sure.  I can verify that the patch series (a) doesn't break well-behaved
modules and (b) it *does* trigger for misbehaving modules (I sent the
VirtualBox crew a bug report for a module that tried to write to an area
marked executable).


--==_Exmh_1293155030_5070P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNE/rWcC3lWbTT17ARAiEOAKCiF4UdJ1HEixtqkm/y8HDMCp/0XQCg7FSx
uaom8HitnXS3acejq/EEylA=
=S4Kx
-----END PGP SIGNATURE-----

--==_Exmh_1293155030_5070P--

