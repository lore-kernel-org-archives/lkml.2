Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1CVB7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:59:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37352 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711Ab1CVB7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:59:07 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Antony Pavlov <antony@niisi.msk.ru>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Guillaume LECERF <glecerf@gmail.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110321231050.942106776@clark.kroah.org>
References: <20110321231050.942106776@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-pmNtEsa7vvYH7c89RG6j"
Date: Tue, 22 Mar 2011 01:58:53 +0000
Message-ID: <1300759133.26693.354.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [02/44] mtd: jedec_probe: Change variable name
 from cfi_p to cfi
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pmNtEsa7vvYH7c89RG6j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-03-21 at 16:09 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Antony Pavlov <antony@niisi.msk.ru>
>=20
> commit efba2e313ea1b1bd69a7c4659263becf43bb1adc upstream.
>=20
> In the following commit, we'll need to use the CMD() macro in order to
> fix the initialisation of the sector_erase_cmd field. That requires the
> local variable to be called 'cfi', so change it first in a simple patch.
[...]

The following change in this series is 'mtd: add "platform:" prefix for
platform modalias', which surely doesn't depend on this one.

So it looks like the commit this was preparing for has been dropped
somewhere along the way to stable.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-pmNtEsa7vvYH7c89RG6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATYgCWOe/yOyVhhEJAQo5BBAAyeCExshUugLNnSZV5WMaPpbsKna7zqCP
ku1VCCPcymtI8In+kckQUycHbo3AqLWcW2HUKi1B5vOjmq0oHwUpww0RKxR8Jiot
0dE53fU8JgFYsnHQ67RuGTCLxHoAwtA3GO4ll21QgAQhWWrUiwuFDlxpUgRaIJf2
EScc8zQ19YOXwL5OsR4XsMaXmM1o+VBavl2Z6+JUvPFXWnYuZYo3KuAe2AYtpD3u
NO5kFzsDo3b65W3TJ1cg8EstcB5A6jyQEQprxTPW1TVtYNZyqJ3YPDx/0uCkWmln
+Ln9vcZmWIgUMkycGsQh+///4wdfVJTq9DmwuaaVKJvH5sqg4nMMM7cn+M/s+Tk0
LNgJNLrYtFMMzuUJY7vKZTE+bw6f+gtRnvTaUIaaYnafx1JQSNgkCpklbaGzJLCR
T811BgPPx9I5ZRGmjnQZBKYDp/pr8CFwumJrSqL1t77dEy417lbP1gy8zrw0RuMl
m1PHRtXDkmxcxdbZjpgeZ6IS18nWeRQLOcVpwLSOoyte4Qc2VxwZOARkvkRbEHq5
xdYAVw3P+1DsOTurPAW6qIi6fTf7vilKtAaDt2OvzKRznuEXSvueSIFf8ORyq+zo
kkCCE0TAaajeM2NZcNow5OqbKyiYXw0frduckCNs7Vy4Y125/iNgpgY4QArVy6oK
FMOMBZpm5Vc=
=sxmq
-----END PGP SIGNATURE-----

--=-pmNtEsa7vvYH7c89RG6j--
