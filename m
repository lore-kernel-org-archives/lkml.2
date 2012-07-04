Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2GDEj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 00:39:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42745 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841Ab2GDEjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 00:39:52 -0400
Message-ID: <1341376784.4852.175.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 04 Jul 2012 05:39:44 +0100
In-Reply-To: <4FF14957.3040007@redhat.com>
References: <20120701172012.078559139@decadent.org.uk>
	 <4FF14957.3040007@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JBhvwaF+ObPUxhzsqVNR"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JBhvwaF+ObPUxhzsqVNR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 09:10 +0200, Hans de Goede wrote:
> Hi,
>=20
> This patch is a better fix for the issue first fixed by:
> "usb-storage: Add 090c:1000 to unusal-devs", so the same applies to
> this patch, let me quote my reply to the stable-review for that patch:
>=20
> "I'm not sure if this is needed with 3.2, it is needed with 3.4 because
> recently the usb-storage driver was changed to report the supported
> scsi level as reported by the device, rather then always report a
> scsi level of 2. This change causes sd.c to try READ_CAPACITY(16)
> first, which foobars up not only this one device, but as it turns
> out a lot of others too, so we're working on another fix
> (and I believe that 3.2 is unaffected)."
>=20
> So since 3.2 already tries READ_CAPACITY(10) first, this patch is
> not needed. It does not harm either, and if the scsi level reporting
> change ever finds its way into 3.2 stable (which it should not
> IMHO), then this patch will be needed.
[...]

Thanks for the explanation.  Given this and the subsequent discussion,
I've dropped the patch and assume no changes along these lines will be
needed for 3.2.y.  (But that doesn't mean I'll necessarily spot and
filter out any such changes myself.)

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-JBhvwaF+ObPUxhzsqVNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/PJEOe/yOyVhhEJAQqInhAA0yWqXGGHYHbGLbvr0D5xI9qQjRN4K0WO
UxkM57lhKC0AWYCg+cZYaTvudxdDhJ5vMJ5Ro0Pvvh+mHowewV9jdDEZEi6N3QXO
wRm4OgKp+G+lQ7THJf60pXjP5TGsNeXg3eR/ITuQd7NJHANf0ZGml3wNl25KSRLf
BEm+/UGaBJiLHeOdcLYscEz2M45n1+84Ib8yw5/YuTDONSx/0xrsyZ1Pjg/3Iluu
qoBjg0DDgIlZhSKIcgLsfHQwmlwXvpJPOj9FuldgALNTzQT8ipBx343AL76EJoF7
xozMWSJNdkmSU1aU7ry/qRQ/p36xTK1tnir4NUgtx/+ehBCNmuiNkUpYqlo98wED
IR0mQdm3GzVWj7LoHPCuf54c7Id3icIdkDJ1X0PRzwPPejmVyGwUHR9KZbjmn/Xo
BGriezrxWU+Jy6BAdGPpmDiORXhvI2DD46dpHVAT8Wm0Mc8ldci5/mt0RiD3UHD1
uKx1nGwNEYLZ5/5sr02+qlwA8K2EDvG7IOqQZU3U8uxWZwpa85zLOIgeZywBmXZj
ZwaFVXDgxGn7JJi4Y4n5sZIl4fEa3UQfiFmGakLV1kRoDvIq3ZL0UdKffoAl8dPg
bX3rNdL7milD7BuMDfE10NjljmQ8N6lHPXmyFdH8n8aEZm8orPqZT28U5IP0rgU0
PY4ZupEJpkc=
=1zBw
-----END PGP SIGNATURE-----

--=-JBhvwaF+ObPUxhzsqVNR--
