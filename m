Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2BYSsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 13:48:08 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:22566 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab2BYSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 13:48:07 -0500
Date: Sat, 25 Feb 2012 21:49:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: r8712u: Fix regression caused by commit
 8c213fa
Message-ID: <20120225184954.GA4763@mwanda>
References: <1330190235-511-1-git-send-email-Larry.Finger@lwfinger.net>
 <1330190235-511-3-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1330190235-511-3-git-send-email-Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F492CE0.00B7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 25, 2012 at 11:17:15AM -0600, Larry Finger wrote:
> In commit 8c213fa, the command to release the firmware was placed
> in the wrong routine. With NetworkManager, problems were rare, but
> when using wicd as the network control, there is a problem as shown
> in https://bugs.archlinux.org/task/27996#comment89833.
>=20

This changelog is pretty rubbish.

1) The subject is rubbish.
2) Which commit was 8c213fa?  Write it as 8c213fa "staging: r8712u:
Use asynchronous firmware loading".  Some of us are really old and
our memory is not good anymore, so we don't know what you're talking
about if you only use the commit id.
3) A link to the bug is good, but please at least put a basic
description of the bug into the changelog itself.

regards,
dan carpenter



--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSS1RAAoJEOnZkXI/YHqRa9cP/1/8zf5dYIw0S35qxApO2DvD
7qAj4I+0mGJxTBR4FR5CzWygec63yX9BAVoJfv6zmJk/ORj49JDs2S4FHd7Nk1Lb
/ItpjqtfWIBcaR2LsBYy/Fm/tFDzTI7ZKl68oTp5JpGAR3RMRcj0Td2byn9pvWdQ
7hArUI696ZG7TMe15j6I4wbvlRZ8mU9BSmH/gEPjgGoIfunnTZ9c67kfcCME9fJv
zIBnijTGgwDh/v8ZpI6tM7+tyTj3fQY+5huNiJbQTHJgKtJd7zVPZZ36ON53Hi8n
uzzC1IKhVTToB5ECz/DnsFO4Mdais5FkcrLRlZUg3Mg167MI3yg+7/JGLDCdK1Aa
l521BCqWnYAtAMoCO72wz9RnJ9rwmcr2DA6Gub4G3n8b3ZKRi5SzZBDjwAW1SkPC
NWFX9ZZ9pbHG0Kx9tJFQbzNB6aHs97kALO/rHJQLEQdN1tGbdEnSLUJ94WAMTwx1
iZsIx8Mg24x4GnNDN2/BppDDTodShLOtERifNySrwDvRDhNl7Fl36GcMYrmGM1n6
rjidTwDhpZrtyGxXD5YIDBXh9sjHcbf64Ff1BdrQYSO/oQigXu+4x8vStumU+bxy
iJuFmKiTC99c8jXJ5I08UH9r/1SgwfLyin1QgaBDjFBNEjtk1gEnzoO28jEKAil8
bYQFLSY2ZWCcVwPQv+zT
=2O3/
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
