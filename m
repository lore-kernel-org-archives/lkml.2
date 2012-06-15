Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2FOCFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 22:05:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53225 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab2FOCFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 22:05:37 -0400
Message-ID: <1339725919.4942.75.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] rt2800pci:Firmware update v1
From: Ben Hutchings <ben@decadent.org.uk>
To: Woody Hung <Woody.Hung@mediatek.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, xose.vazquez@gmail.com,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Date: Fri, 15 Jun 2012 03:05:19 +0100
In-Reply-To: <1339657061-19482-1-git-send-email-Woody.Hung@mediatek.com>
References: <1339657061-19482-1-git-send-email-Woody.Hung@mediatek.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7k35+b9Q8cVEmescWFBh"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7k35+b9Q8cVEmescWFBh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-14 at 14:57 +0800, Woody Hung wrote:
> Update firmwrae that support the rt3290 chip.

Applied, but:

[...]
>  ------------------------------------------------------------------------=
--
> =20
> -Driver: rt2800pci - Ralink RT2860, RT2890, RT3090, RT5390 wireless MACs
> +Driver: rt2800pci - Ralink RT2860, RT2890, RT3090, RT3290, RT5390 wirele=
ss MACs
> =20
>  File: rt2860.bin
> +File: rt3290.bin
> =20
>  Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
[...]

Maybe this licence text should also be updated?

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-7k35+b9Q8cVEmescWFBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9qYX+e/yOyVhhEJAQq6Bw/+K9mFhrlh1w0IlpwX9F/TKpBhZ+Dd3dpn
ym+EsNeiVKzmkCIaDzhOZE2i5HC6uNrvC6y2Olc1EMgajsHWblFvAjdxa5RBxnM7
Pcq0egqyGAGdBQDxXg6v2CdzQ6xZcOe4lh71hXCjXw3cypKxxBf7IoEl7cCVkHii
b3pBa7ju3Wwy5z+vgzp1TmIcm+1S8iOLf05JDvmQyrxHgUkN0IPlGz2SsjAsI8eM
MrS9Oiw7cjmBsiq6Nk/mbJarvQf3Rur1zqRPtsY03eugu5HoXzHr3wjs5FM2e6VG
2vEAL1lt5BzGq0R/INI4IED9LkJV4b71mE2iDwaC9FMEOcXw/fCES9/98JzXWjGx
zoWRas7H1O4q4nyvOYDH5g5rJPcSVDBAcuNWhuglfT5hWGvOsaSdvFw/dADUhqad
NB8wEGq05lFNrUCQA+onzTeOLFDiyTZ+QdoVtDjxLb8J4UDTtPzIFS3I8NG3BpCp
DASd2yat2VzoJo/+AgoE9RqjS69/T0WfBIB7WHOzgTvCBREuuoCdutT3107kwqWw
31Cs+cmA2DGcLk7vNDdOpVGTCQqVpu3sgMwn0KMY618u31DQ6c0gkb/hHxA+1FvL
JEVHNdM3UZzPe7yZvzhN3+LlZckWI7vCPfojlWZLbRwTS8an/M2ff8sUtQsXgM9b
TQfFjhwTzgE=
=xgQ3
-----END PGP SIGNATURE-----

--=-7k35+b9Q8cVEmescWFBh--
