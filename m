Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2GEMGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:06:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35561 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab2GEMGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:06:02 -0400
Date: Thu, 5 Jul 2012 13:06:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705120600.GT4111@opensource.wolfsonmicro.com>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
 <20120703123552.GC25995@sirena.org.uk>
 <4FF2EEA1.6080204@linaro.org>
 <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF2F82D.9080507@linaro.org>
 <20120703142123.GQ29030@opensource.wolfsonmicro.com>
 <4FF54406.3000307@linaro.org>
 <20120705094541.GK4111@opensource.wolfsonmicro.com>
 <4FF57EA9.7060107@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doRsZBpDQ+I4/+/t"
Content-Disposition: inline
In-Reply-To: <4FF57EA9.7060107@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--doRsZBpDQ+I4/+/t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2012 at 12:46:49PM +0100, Lee Jones wrote:

> Besides, the main role of Device Tree is to eradicate platform code.
> Whereas the code in the MFD driver used to register the AB8500 devices
> is not platform code.

Right, this is a big part of what I'm saying.

> Does that answer your question better?

Not really, no. =20

> >> By the way, this patch has nothing to do with registering these
> >> devices when DT is enabled. The code already does that. This is a
> >> bug fix, to stop multiple registration of the ab8500 when DT is
> >> _not_ enabled.

> > Really?  It seems really surprising that adding more DT support to the
> > MFD core would have any bearing on something like this...

> I'm not really sure what you mean by this.

You seemed to be suggesting that your fix was in some way related to the
DT changes in the MFD core.  I'm unsure as to the relationship here.

--doRsZBpDQ+I4/+/t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YMhAAoJEBus8iNuMP3df4QP/jPjybznwL8ptYvjORHPDJwC
gufNckWIce2mJo3h3p4DDFhBK44FXk4pwL8taoxCobZp+oAAx2Hu+5gMNxo4y8zr
oLhuDbl5AtodeNsRT+l70t8gRnkCMrPAzA+N2fTgaqOHVMyGE2qbHLqHfvQInzfw
uCAQbKMfu6V0AfR1dxr+R3ybUDS4WAiKRxKMjkBGY7SQRorJItZCg4WhL+hRLopU
U201MBW8Etqtzrm1Hr1NpLbOkpo+9nRkoWTQ1olq+BncOW5QEATTXBa7PJcyVA14
WnPZVSMqdnnEwx1HXP2TQTVblVOU0ulpa8bz7Sic/Zt21/Ds8tFus57/aNdH9GMi
oQQ1fxZpcJ2GwSFkyjnle/au/tkY7nH7pGteeTsxswlxPMYNsyFUUMZ9RS/CtpZW
wtGuin5ZzD0bGu2gsZOJjbMokhPvNSgVLWDYoKaHvRCld1dG5H7bHg0an5XxB504
nzzswcjEJv8wKeyA6+ORWZvNo4v/v7SCCwH0CezCl2LJd86ona+aZtDrYmOKJQwT
0Ey7uYu5t5bzB8uXmPqAwt9j0ttJTFB0yTTNosnHmmK9boGHevLLkNXrSyX/2PC1
8pSwXPQl1aYF7b70HCgS9U8hfNFVcrOOpMeyX64z15gxa2NGeg9NkeDbj+MO5KcF
akL6VGs/is1z5jzhtPuM
=F1ct
-----END PGP SIGNATURE-----

--doRsZBpDQ+I4/+/t--
