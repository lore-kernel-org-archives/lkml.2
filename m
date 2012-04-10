Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab2DJIlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:41:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45256 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab2DJIlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:41:09 -0400
Date: Tue, 10 Apr 2012 09:41:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] regulator: Fix a typo in da903x.c
Message-ID: <20120410084106.GE3149@opensource.wolfsonmicro.com>
References: <1334036844.15859.1.camel@phoenix>
 <1334036964.15859.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pY3vCvL1qV+PayAL"
Content-Disposition: inline
In-Reply-To: <1334036964.15859.3.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pY3vCvL1qV+PayAL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 01:49:24PM +0800, Axel Lin wrote:
> Fix below build errors which is introduced by commit c172708
> "regulator: core: Use a struct to pass in regulator runtime configuration".

Applied this and 3/3.

--pY3vCvL1qV+PayAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBAgAGBQJPg/IbAAoJEBus8iNuMP3dttYP9Al8843BITtAXdtAklvVk2pV
souDMt/E/fwcaN+/nmegiNzrEYYIGebldKMVQUF9DUHM24YKsNf6SLrmM+wWdcXZ
feGVhevLIfUvjrJRLueBCuaG3L7UB7KxYA190slFWpo2iX+ElLyZPSdUueJ9rb+J
5j7sRXfNF4wqVqJ8kWYOZ06f5bAsFHOWLl1fiNcyrnxLEiYw93guk98nWfdWY4jD
IQGfRDik3qc136MJbIkxD36bqsviyO/bq46aMXq9TOPWLBPuSKyR3vdEsLgIu5lt
1JthD3YD7SagZiZB4Rj25zt7ML/2Ht7nitHtBL4v/+oZOLI+CSNT0q7PhTYfeg6w
+Ny+yra7NHQt6P0dQ0S7DZpXDgG+J3sI2/PJknHpdp+Be9NtnKsDpUZ7OYZL5QMV
58Q893qCzowiFEUVcuR1DAPQdleMHmpJ3WgqKqVzrUOBB8FZ8ShIsbbKgtB/17Bv
QS7OKvGYk4tN2Czn76UG7YQd+92GnPY7f1xkF3ZIU3eS5/qwczKLIJjEyi7+wZp+
E2Ia7AwIgzA7yIj5sbFIBOmdRGJcbtFly1cU0UG5XM/hLsj5JoTqCjiWJmKAws9U
WQ8Rc1jEPu/w7xiJyKZV84rpkXqkBwtO2iPsP/0V27lBkT0+Buyw5Bg6oXm8Y+ks
SN7xFAb85x9/KvoiQ+A=
=iItF
-----END PGP SIGNATURE-----

--pY3vCvL1qV+PayAL--
