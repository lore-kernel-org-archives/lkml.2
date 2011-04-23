Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1DWAUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:20:38 -0400
Received: from csamuel.org ([74.50.50.137]:56390 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab1DWAUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:20:37 -0400
From: Chris Samuel <chris@csamuel.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 10:20:21 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
References: <201104222333.25546.chris@csamuel.org> <20110422134648.GB23965@elte.hu>
In-Reply-To: <20110422134648.GB23965@elte.hu>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@
 =?iso-8859-1?q?=5ESdaXtmdYGRq=0A=09=5B?=>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<
 =?iso-8859-1?q?=7Bn8m=3BX=5F=0A=09g=5CY9LQ=3Dv/b5=60?=)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)
 =?iso-8859-1?q?F!1M3=3Dw=3Ai9MsWp=26v=3B=25usOXL=3Bw=0A=096kF=3FwAZjss=2E?=
 =?iso-8859-1?q?+y?=(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1778686.OYxBQx9UpA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104231020.21557.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1778686.OYxBQx9UpA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Fri, 22 Apr 2011 11:46:48 PM Ingo Molnar wrote:

> Have you tried the earlyprintk=3Dvga boot parameter yet? Maybe that
> shows more  than just a silent hang ...

Thanks for that, just responded to Alan's email mentioning the
same option - I'd not come stumbled across it before.  It reveals
the cause is the kernel misdetecting the amount of LOWMEM as 16MB
and, I suspect, is the same issue as I had an offlist conversation
with H. Peter Anvin with in 2008 which tailed off due to work
pressure on his part.  There are more details in my response to Alan.

> Other than that, do you have some other box where you can build
> bzImages for  this system in reasonable time? If yes then you
> might be able to bisect to the commit that broke it.

I can indeed, I'm lucky enough to be able to build that image
in about 4 minutes on my production desktop.  Is that still of
use given that there's now a better view of what's going on ?

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1778686.OYxBQx9UpA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbIbRY1yjaOTJg85AQLneggAiR+jpq8xlmM1uM0cgjTpBIjq99cz4fEo
XslM2xsc2DZPZt8riJno88QlHVTFr40QIIm/GV6iiM7K8ugOsgJdP2MXvxtRMz/K
UZxR2DoQMooXPo4X1k8DDxcJRvvK4IGdRpEfNyO9FVO+mIXEUpHHnv/PIqs8hHp/
UY426soxuWMwOxNs4Zaf033AyHAGY3C8AzC8ZsOCwnL6l/ZlFvl1gOgBFOMA9brv
tt0JPIwaKpdPatRUVD0rok2ymVBsJtDP0oF0GHgZkgXmRyvh9XTVI1GGeE/U50E6
6oe2vh6iQ6OMZI8XH5/PGfhA51LDw2FNnn3UP9vU5EPWmHm7uBhPOg==
=DDV9
-----END PGP SIGNATURE-----

--nextPart1778686.OYxBQx9UpA--
