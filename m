Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1LFGKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:10:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40906 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1LFGKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:10:14 -0500
Date: Tue, 6 Dec 2011 09:10:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] staging: vt6656: aes_ccmp, baseband, bssdb, card:
 Change BOOL to int
Message-ID: <20111206061018.GD3374@mwanda>
References: <1323047566-12650-1-git-send-email-marcos.mage@gmail.com>
 <20111205065517.GC3236@mwanda>
 <alpine.LNX.2.00.1112052237140.2379@cactuar.localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1112052237140.2379@cactuar.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4EDDB1C1.0042,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2011 at 10:41:54PM -0200, Marcos Paulo de Souza wrote:
> On Mon, 5 Dec 2011, Dan Carpenter wrote:
> >On Sun, Dec 04, 2011 at 11:12:46PM -0200, Marcos Paulo de Souza wrote:
> >>This patch change all references of BOOL to int. As asked by the TODO
> >>file of the driver, we need to remove the ttype.h, and this file do a
> >>typedef of int to BOOL. We don't need this.
>=20
> Dan, I'm trying to remove this chunk of code:
>=20
> drivers/staging/vt6656/ttype.h:
>=20
> typedef int BOOL;
>=20
> Are we talinkg about the same BOOL type?
>=20

Yes.

> >
> >Why not use bool?  Especially inside structs bool takes up less
> >space than an int.  Also static analysis tools care about the type.
>=20
> This typedef is about a int type.

Yes.  I know that.  But these things are used like bool not like int
so bool is the correct thing.

Bool is a different type from int, so you'll have to verify that
changing it doesn't break anything.  It's a more difficult change
but it's the right thing to do.

regards,
dan carpenter


--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3bHJAAoJEOnZkXI/YHqRDw8P/2EUIx4CWYo8tbZXWfs3mO9m
dqC3YM9BmKoq2kbtNiShMJZWy+NpLR9EiuZgXx7gw9b7Ub2YR9+vqT1+DrhoKM5o
PXURmLmesVJBa2ANNJuQpSm40rLXOVWIofSXNRpZhKXwRAP3gX04DSRc+PS7Gl1s
g97osv3OPts1Djji20cnroCkvdzBhaTPVVQ3VWXgVfyJJudD/OKxSr4tCg9L7EY9
IzKe5xBODxEX7zLDgcFl9tABYkWVRCDOWNeVKXrv3bVfIKPCHGb2vXlajW1VJtVl
UK7VnCW7XAMmkwVvz39SQBJybNG6D/gvBU/eAVGK8cXlobVR0yd0ta3WPvaYe1Hx
gMPJdf4TAla/dd00rb1F0aDbkVDJhqkUU5Riy8DVLdetR9JedALpPDa8cehHWxGG
wV/iUVVIba2zkcn72d2lpfHKTMEkWMz3qa0Cp3uCUXaYSKYbmADkFB1aUQhUEYN5
SQEzJCqn+XTrsaV7vzVTiJ1HMgaq2po+HpD1B68tKU8tvimcu2yCZDrVnaqKPOwF
B9tyBLtUxrSDzBtXh/0B3VO8IUuq/Q1LKXyJKVV2V1aLu64MI7dMa1IhG0pE7J+W
UchtY2rwFFbB27nUjPtYp14MiF+QS1BdHmqoWYPXD7eP26VuFogi9lYt8TMo8chw
VQa4Y1PTdYn3AQ4hzrYx
=T3bU
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
