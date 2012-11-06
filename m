Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2KFFbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:31:06 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52712 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2KFFbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:31:04 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.5-rt14
In-Reply-To: Your message of "Sat, 03 Nov 2012 20:04:58 +0100."
             <50956ADA.6090108@paradoxuncreated.com>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.2.02.1211012148170.2756@ionos>
            <50956ADA.6090108@paradoxuncreated.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1352179845_2044P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Nov 2012 00:30:45 -0500
Message-ID: <91465.1352179845@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.5098A086.0113,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1352179845_2044P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 03 Nov 2012 20:04:58 +0100, Ove Karlsen said:

> And have you given consideration to the fact that most distros and OS=20
> grow with some levels of bloat, and everyone can=60t be an expert, so=20
> maybe one shold consider a (scheduler) queue for =22bloat=22, and one q=
ueue=20
> for main app, so that even bloated distros can run with the jitteramoun=
t=20
> of a highly specialized distro? (for instance=20
> mainapp,service1,mainapp,service2,mainapp,service3), if bloat is on=20
> queue 2. Or is thins kind of thinking already in batch, or idle?

So how does the kernel know which one is your =22main app=22, and which o=
ne is
=22bloat=22?  Hint - you can't base it on =22the main app is the one usin=
g OpenGL=22 or
similar rule, as there may be multiple processes doing that, and you may
consider one of them to be bloat - and *I* might consider that one to be =
the
*important* one.  Or even your definition may change around during the da=
y - if
you're running Doom3, an OpenGL-capable window manager is probably =22blo=
at=22, but
once you exit Doom3 and start working with multiple windows again, sudden=
ly
you're going to want that window manager to be the =22important=22 proces=
s again...


--==_Exmh_1352179845_2044P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUJighQdmEQWDXROgAQK9ng/6Amp9eaAM5NqiLh/yzTjOideXGLkd9MOc
iicwG62XI9v0XPLE8loYQ9jFk2xuTeQCO0WjQBWI8vUR3yhBIVKY7qTsSAgmQYES
DjpZe1vsUSXsdugU9Ce2ku7lrTFceVEE5HFG0gDdiZaqwd6FEc9eQs+V2W1JXIXR
7G2G7w8S7hlN+4Bi7nJSHF7sRZx6XTDrMfw+h/TYca9UL8Shnbwg4qsCNmJxbhtR
tL39TMWf1lAoDxKGBke51mRPdevwpn0wbWgNOdZqk+mFIGbl5XXKB88bD29T3Q2+
kRZmXyx7x8qlDFO4PQPieYEfnE84x5U+5fWMqqJZ8DF2A+H/Px91JVisNzPLvutV
dZIfvXT7V3E7ZGMGM62bQ6LHjM9Xa2+5No54jrf6+tpBz5VZp9vGS6ysADQaXCvD
/MQE8RXycrQwA3EqhYKJnwunYcw0+vaf9A71JfPVm628oMxDriA1JhHaBFitlOoI
jG/bQJnieIDdUkRy8iT5KorgSonlXl+gvW1nOFgZU3U48PJzfdR2U4YMbyyPfPWa
3Je4LSLo8nmQhB094DUJM67FM5PZxkeHWhYKHpJ+vcRWPTDwmBJt7SLEGx3AizRT
ILu+eIVIvA5GCPB1FvMJ1s9O/wNGY3uy57wBXEXbqRjTLSFZ0eKN8xdtpivgPaLc
iVLZLTz98vc=
=2jMx
-----END PGP SIGNATURE-----

--==_Exmh_1352179845_2044P--

