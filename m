Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151Ab2FVDxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:53:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37277 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761121Ab2FVDxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:53:43 -0400
Message-ID: <1340337209.6871.179.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2.y 3.3.y] staging:rts_pstor:Fix possible panic by
 NULL pointer dereference
From: Ben Hutchings <ben@decadent.org.uk>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wwang <wei_wang@realsil.com.cn>,
        Hitoshi NAKAMORI <hitoshi.nakamori@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Jun 2012 04:53:29 +0100
In-Reply-To: <1340266719-31983-1-git-send-email-kengyu@canonical.com>
References: <1340266719-31983-1-git-send-email-kengyu@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bIOpS249rMsnRDUQ0K8l"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bIOpS249rMsnRDUQ0K8l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-21 at 16:18 +0800, Keng-Yu Lin wrote:
> From: wwang <wei_wang@realsil.com.cn>
>=20
> commit 0d05568ac79bfc595f1eadc3e0fd7a20a45f7b69 upstream.
>=20
> rtsx_transport.c (rtsx_transfer_sglist_adma_partial):
> pointer struct scatterlist *sg, which is mapped in dma_map_sg,
> is used as an iterator in later transfer operation. It is corrupted and
> passed to dma_unmap_sg, thus causing fatal unmap of some erroneous addres=
s.
> Fix it by duplicating *sg_ptr for iterating.
[...]

Added to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-bIOpS249rMsnRDUQ0K8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+PsOue/yOyVhhEJAQr9ahAAhpr5nftvY4jGlOFVuC7z7HPgBeJqLhaD
bnhmlZAVTi+E4dx1kN4bj/Vg3IdSpXNCbzYsFqkww+4iMOVJUruHOYEUFTrOTzxd
mXqTPEgEqeTrSfdYaI7yAVhaP0yUzQce5Ib17uQ8htihlYrMgXzxeGotrk1UOber
99UWOhHEBeaI/Lkc29EN7Tv1TFI4f+ErgX2d2ovXyAlU6Rg0QQlX2nMOvZxZTx7W
7B+mrf1gnDFW9YYgfBIwmqWADx0ZtmAU7yrOFmjIRO8KSyuHq8GmNM0OfPxcy1uV
Iy/qn3lAKaVprri/Q8dNnbcJSNIkFfthJzSnwBTbL+Dq4AgFq/ueGueCOgikcM7k
5ZXQW6Xg+hejrC9WO/2Yyq3jv4K0QBpqcGlcOB7dWESbPcKn5ugliNlK/npgoqKo
zVVGwCrRYtBCnzob6WG/RB4NLhrvWpk4W+/f/vrkzrgBpqUryM2PWNWiPDgVWXyr
umVMvEMMQSYJHT+N9Gsq0HYQKuf5W1TEgJ1C18bRjni7BL4ykAGbASJrVlyfPgY3
E8sZQjFUeQzmrnY2w8d3nK6bmpiY12lGRduiiGY7eMnInnJ9T5OnAL09iERcWarS
s66Jv/gvTWtyMZkJnBNGyGGg20JxplHWkUgHqwqT5vge0dSJQrJtD5Re8Evf4XCO
HbpQiWa1D20=
=8obw
-----END PGP SIGNATURE-----

--=-bIOpS249rMsnRDUQ0K8l--
