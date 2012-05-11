Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2EKDEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:04:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932373Ab2EKDEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:04:21 -0400
Message-ID: <1336705456.8274.428.camel@deadeye>
Subject: Re: [ 034/167] [PATCH] usb: gadget: udc-core: stop UDC on
 device-initiated disconnect
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>
Date: Fri, 11 May 2012 04:04:16 +0100
In-Reply-To: <20120509191950.GB15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
	 <20120509055034.318079643@decadent.org.uk>
	 <20120509191950.GB15527@herton-ThinkPad-T420>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RZrqEJEASoUaHdGtWo/P"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RZrqEJEASoUaHdGtWo/P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 12:19 -0700, Herton Ronaldo Krzesinski wrote:
> On Wed, May 09, 2012 at 06:51:03AM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Felipe Balbi <balbi@ti.com>
> >=20
> > commit 6d258a4c42089229b855fd706622029decf316d6 upstream.
>=20
> We also need a follow up fix to this, commit
> 83a787a71e034244a9fd1d5988fe18f226341417 upstream.
[...]

Right, Peter Korsgaard already pointed out this and commit
320cd1e750f1bf3e47eb41209dcb2be07264cb76, and I've added them to the
queue.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-RZrqEJEASoUaHdGtWo/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6yBsee/yOyVhhEJAQoR3xAAwayWyax1JRabuB56ywWWjutRtiplZqFY
jR5h6vywAibLe6BZVmejPFwLRjbu5NZDBlEIFXEnQ2s2E1AXxrtjkdVi2mcvS5tY
UD5DgkCOI/dhb/nrHL3jvKHqh1sV2LhsvqveVxJ9s3Z8lSUv4n8W5+Gb3oXdmGaf
pnU+NPBoZo0wjUmUWHGRGCogo1l1qqenD5Ljq4tp54alB+xaVlTZuy5TresVM9Px
BU0cpbpfHSfyvo0J2SB3ig2jLKfuqiVAYXoOg6f1ZS4R9CyALoAVc6KSy0BS0RAO
XVan3GToAOl+3IVV+h/ekaBD2HJSKwg/wf9JGUa0NPU4vOf9AiCdtnuegu3zZLWf
aOrSAbUmbGoJ1/VvEWgYhoP8xcDHurDxlv/A0jqcSsQIkQgzHa71Lc8iikFfjhJe
fFApDMupt+GH7r5BYGU1lWYAZ69OzThgyGiI4UV/MXhZFhRjdZdxLfYN8BP3iesl
+ZwPVzfIwSTw78xDo0bBChZ8mQxqRcuaidro8PGHs/AT8j1PfzWt5eC2grBFAge6
b/7tNkQiA9VNnP8usO5uClTUbIfXvxqFHSOr3I4woPEHUTkID5vwjhJf4JgOibe+
jHc3nmsqD0SBpU5wyISNTQc2/+PQ68AvS3wcpBhgPuF3/xPUfz+qR8Q3/4EFQYb2
VkHJfLH7CSQ=
=h54U
-----END PGP SIGNATURE-----

--=-RZrqEJEASoUaHdGtWo/P--
