Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab2DPKwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:52:21 -0400
Received: from edge2.cs.stonybrook.edu ([130.245.9.211]:40767 "EHLO
	edge2.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2DPKwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:52:20 -0400
Message-ID: <4F8BF9D0.4090104@cs.stonybrook.edu>
Date: Mon, 16 Apr 2012 06:52:00 -0400
From: Richard Yao <ryao@cs.stonybrook.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120406 Thunderbird/10.0.3
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How do I detect a block device is being used as swap inside its
 request queue handler?
References: <4F8BF514.509@cs.stonybrook.edu>
In-Reply-To: <4F8BF514.509@cs.stonybrook.edu>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig9F50D7596E6FEB7A3A1A14A5"
X-Originating-IP: [72.89.250.133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig9F50D7596E6FEB7A3A1A14A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/16/12 06:31, Richard Yao wrote:
> Dear Linus Torvalds et al,
>=20
> I am having some trouble with an out of tree module for a virtual block=

> device driver. I need to disable the direct reclaim path when the devic=
e
> is used as swap. I cannot see a way to detect that the device is being
> used as swap, so I am currently disabling it unconditionally.
>=20
> Is there a clean way to detect that the block device is being used as
> swap? I am not subscribed to the list, so please CC replies to me.
>=20
> Yours truly,
> Richard Yao
>=20

Please disregard my previous email. I just discovered a deadlock that
can occur if this were done.


--------------enig9F50D7596E6FEB7A3A1A14A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPi/nTAAoJELFAT5FmjZuEhREP/1LivjU595plbUWf7NNN0brM
r90K0FMo1uVvVVG14yTkIEboy9FOJL+vLHTDev7c/Oc7rXTMH/Hm4FdJbBlaU+Vl
o9GEqoiQEXqYcGeXxZ7RgHbzj1VXh0nXy6/+IhowAJpr/z1/Bqz9u2qFO+UcWOqc
TjL1jpzLf3wVmwuHk3K8QBYvAMQ0gYS2SfSQBh1YQ79CauHHKCE2MPJ2qEMSqMAl
7df5Y0UcdISWLgVVjxZounIr8k/YrJny3mD+iVVy8Zxd+PB9C4o5hisc5kWdCrtb
c2aOWr+lCEZ33FbE4wOv6uX62iwxuJX3YBvBgMmVYrE/rNVLqRKCi0Cr4YUzV4pH
g9kp9fyrfhWnvvRTA8rvQCfeUOZnMizaXVF5j5TxA8fscWh5NfOHGx1czRInV4WX
0WCejSskOBoj0kA2CnWseGNuII3Z4MTnir6qRWZCGDt9BHC/4DCiVkIMrvxdjhbo
u8Lwlyr0HFAmPJuHuoPCLfEzi09atpsYS3jXsNumY5QPP0v/8XzKrKG/hKMe2PNF
odpDEzETLAJXbfJXRob7Q4jShIbkCNlXRHj02kbPZ0OGQdIQKe6IFiCcrG16k9YT
BvWNqT5D5Am4ln0RAFZuHBZoR6JVvVTUYNsfJilRfWnI+wndV0viYPVcmHMF7NGG
jgJSvdimZ4jkRRzoYMeI
=TWT2
-----END PGP SIGNATURE-----

--------------enig9F50D7596E6FEB7A3A1A14A5--
