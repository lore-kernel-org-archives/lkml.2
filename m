Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1DWLch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 07:32:37 -0400
Received: from csamuel.org ([74.50.50.137]:58377 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1DWLce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 07:32:34 -0400
From: Chris Samuel <chris@csamuel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 21:32:10 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <20110423103536.1c7ff2a8@lxorguk.ukuu.org.uk> <201104232036.02758.chris@csamuel.org>
In-Reply-To: <201104232036.02758.chris@csamuel.org>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@
 =?iso-8859-1?q?=5ESdaXtmdYGRq=0A=09=5B?=>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<
 =?iso-8859-1?q?=7Bn8m=3BX=5F=0A=09g=5CY9LQ=3Dv/b5=60?=)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)
 =?iso-8859-1?q?F!1M3=3Dw=3Ai9MsWp=26v=3B=25usOXL=3Bw=0A=096kF=3FwAZjss=2E?=
 =?iso-8859-1?q?+y?=(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18110169.x8QqibpR7K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104232132.13849.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18110169.x8QqibpR7K
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Sat, 23 Apr 2011 08:35:59 PM Chris Samuel wrote:

>   On Sat, 23 Apr 2011 07:35:36 PM Alan Cox wrote:
>
> > Ah.. do you have a BIOS setting called something like OS/2
> > compatibility ?
>=20
> That's the really odd thing, I am yet to find a way to access
> the BIOS settings on this beast. I've tried the usual DEL, F2
> and F1 with no success and there is no prompt I've ever seen
> to offer access to one.  I do have a ZIP file that contains
> the last BIOS upgrade for it that was released so I'll see if
> I can make that bootable and see if that reveals any options.

OK, that ZIP file doesn't have a BIOS but it did have a BIOS
configuration program. I have a "Primary Operating System"
option which is currently:

 UNIX, Novell, Windows NT, OS/2, Other (Multi-Processor)

The alternatives for that option are:

 UNIX, Novell, Windows NT, Others (Single-Processor)
 DOS, OS/2

The README accompanying the ZIP says:

# Due to a PentiumPro bug the BIOS need to know if a Multi-Processor
# or Single Processor Operating System is installed to correctly
# set-up the local APIC and MP table.

The only other options that seem like they might be relevant are:

 Extended Memory Above 64MB Support - Enabled
 Video Shadowing - Shadowed at C000: and C400:

As regards memory it reports:

Base Memory: 640KB
Extended Memory (Contiguous): 255MB
Extended Memory (Non-contiguous): 0KB


Anything ring any bells there ?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart18110169.x8QqibpR7K
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbK4uo1yjaOTJg85AQL3hAf/WKJigDHrKRmdpS1oU96hyy37Qc/HvyYT
thsIEC9uFIGm4LAznsAgqc9NKOqXzSRkQlEuISlq51FdI618MfNqYBNZhDiH8Swb
yphwrjNsUvPScfrcbv79v52NsuS/Cmbrabnj6camFnP0/U5f1yHhP7zvrj0ZZLqj
Wq3igxF5rWi2+L3IwWcA7OKDUI8++WdTEWXgQbV+WNbNTSKctEO8PtXcvgMxcgQn
yHt+UzB3sZEpCF4mRFA7D0YXw4jwsTzNbNhVpqxE7xDIsQ1bamzI8kvzFdLysGek
6giLYHus8V4XNzUCoDrXEEK5mCjoiurY6JuKvWe5kvGeLaPUJ4E75A==
=LtxU
-----END PGP SIGNATURE-----

--nextPart18110169.x8QqibpR7K--
