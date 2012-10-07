Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab2JGAzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 20:55:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57665 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab2JGAzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 20:55:09 -0400
Message-ID: <1349571292.16173.78.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 28/52] xHCI: add cmd_ring_state
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Miroslav Sabljic <miroslav.sabljic@avl.com>
Date: Sun, 07 Oct 2012 01:54:52 +0100
In-Reply-To: <20121004210638.880914187@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
	 <20121004210638.880914187@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QfWYQSFZQAg0S7tPK7ld"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QfWYQSFZQAg0S7tPK7ld
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-04 at 14:21 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Elric Fu <elricfu1@gmail.com>
>=20
> commit c181bc5b5d5c79b71203cd10cef97f802fb6f9c1 upstream.
>=20
> Adding cmd_ring_state for command ring. It helps to verify
> the current command ring state for controlling the command
> ring operations.
>=20
> This patch should be backported to kernels as old as 3.0.  The commit

I assume this still needs backporting for 3.0, since it wasn't included
in 3.0.45-rc1.

Ben.

> 7ed603ecf8b68ab81f4c83097d3063d43ec73bb8 "xhci: Add an assertion to
> check for virt_dev=3D0 bug." papers over the NULL pointer dereference tha=
t
> I now believe is related to a timed out Set Address command.  This (and
> the four patches that follow it) contain the real fix that also allows
> VIA USB 3.0 hubs to consistently re-enumerate during the plug/unplug
> stress tests.
[...]

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-QfWYQSFZQAg0S7tPK7ld
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHDS3Oe/yOyVhhEJAQo6Ig//b2pJz4pqSQYGIQz5gdo9guK0fUDGmlY6
HQV4FdKaPI2t1Q+UK6AHnCcMms6+hEmv+UcVP75OxYiB34WARRFXz2BG1PX74Cvt
72pQ1xAspiCJ2DBWZg2SVuLdnGYCZI77x6sLMjTEgCbf9usw7ls8mp7PmpbTrBrq
RsEnCD4asgN4TMR9eWjRbsta55AsxRK5SlQB47JyHAW5gtKxC1o/8LS6kwYACZ+r
UvLRIOheIYlsld/5i1zF+LsKRmDhgy8V02xyqYwSGuj64nWvT3kxNx6U8ZAznd7S
KwAdDTriF5cXtuQVOMbZLWOAxLiNPe/gkJLOoiuHytNPJeBuibujjZp0qtaRsGFF
KtnbFmTaQ69VQAFS+8K3LalqCrC0oJI8bL/P0JRfln0j+O6VwBAWbsCUTYCY5q5Q
TOU0c/XrV5K8nc75WPJcBwpKpcWSktlqIIby2zFkkf09FWs3J8CNI54u4avfRsWR
SWNbaHF4Q0Cvyd7lupVVsqVydn4sjEChTJ0Rv3I5lxE0gdrt5LbboFQilD4kY33L
AraUpsdkyEExX7cKsM44xGYVyv/5YcT8u1SgjOXOKtIlm+qiaYlVczzenCJCJVDt
4IbIh8Z/L01aYgMXCnV/J+AnhrhPz2uybYewkAAuy5SJ1wLi2rlM29Cw5W0/qeOv
6/Oo4Lzfyao=
=4/qI
-----END PGP SIGNATURE-----

--=-QfWYQSFZQAg0S7tPK7ld--
