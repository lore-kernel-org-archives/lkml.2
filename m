Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0DLJsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:48:13 -0400
Received: from k66.ru ([87.224.128.21]:28765 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0DLJsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:48:11 -0400
Date: Mon, 12 Apr 2010 15:48:07 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.sourceforge.net
Subject: Re: [lxc-devel] OOPS on lxc-stop
Message-ID: <20100412094807.GE5745@wrars-comp.wrarsdomain>
References: <20100411170542.GA5745@wrars-comp.wrarsdomain>
 <4BC2E918.50604@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <4BC2E918.50604@free.fr>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2010 at 11:34:16AM +0200, Daniel Lezcano wrote:
> At the first glance I would say it is related to the FAIR_SCHEDULER.=20
CONFIG_FAIR_GROUP_SCHED=3Dy

> After having multiple Oops on my host, I decided to disable this option=
=20
> in the kernel.=20
I will try it.

> Does sysrq + t show something ? Or the host is definitively stuck ?
Well, I didn't try that, because I didn't try to reproduce it without X11
yet, but I'll try.

--=20
WBR, wRAR (ALT Linux Team)

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLwuxXAAoJEOih81koZvPBP3gH+wSGuHZzAdbxm8hpZcwLGLZF
53qi4oqTJQI+DJNsPXH8F8oKjD3gR6e+kKJwsm2olonoJoDMl0ieNnfy7M+CxYzf
jko6dJOCxkvTm1NIu9rwO/kLeOwK63QsqFspNSD2pidS0sq1+kNrqMYe9ZwVZjKw
/gswr++qLxgI1v/fjyFcQqWT4rK3f5kRpYGGORzwzAALRt8R8MwM2CWeVyXmfpcG
Q63sAeu+Q0Dbi0LUa3qRExwbcth68ppnPt5g7bSohAP5YQTyuEVOrmfCI9MhoMzP
IKze4Y6Rj1r1NJubIEVooKEh7e4WsfbFota/sHYDTt13Bfo2iGCw8GCLp6AuyMw=
=xIOl
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
