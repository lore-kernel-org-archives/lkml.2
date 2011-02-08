Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1BHOAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:00:05 -0500
Received: from swan.madduck.net ([80.68.90.58]:43207 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1BHOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:00:04 -0500
Date: Tue, 8 Feb 2011 14:59:56 +0100
From: martin f krafft <madduck@madduck.net>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Opteron ECC/ChipKill error
Message-ID: <20110208135956.GA7055@albatross.oerlikon.madduck.net>
Mail-Followup-To: Borislav Petkov <bp@amd64.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20110208133010.GA26487@albatross.oerlikon.madduck.net>
 <20110208134910.GA3849@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20110208134910.GA3849@kryptos.osrc.amd.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux 6.0 kernel 2.6.36-trunk-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Borislav Petkov <bp@amd64.org> [2011.02.08.1449 +0100]:
> It is a DRAM ECC error on one of the DIMMs on your node 1. If it is a
> single occurrence I wouldn't start to worry yet - I'd monitor to see
> whether the same row above (row 6) starts increasing its error rate.
> Also, sometimes reseating the DIMMs helps.

Thanks. I really hope this won't happen again as I really don't want
to go to the hosting place and open the server. ;)

> Can you send your dmesg please?

Don't want to spam the list, so:
http://scratch.madduck.net/__tmp__dmesg.gz

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"women, when they are not in love,
 have all the cold blood of an experienced attorney."
                                                   -- honor=E9 de balzac
=20
spamtraps: madduck.bogus@madduck.net

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQLvBAEBCgDZBQJNUUxcwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xOxS
EACfwYZlRK4qSowWD25PItVxdz0YQOrJjhZLP5n96MSl3avTesO71+RYNmeGPSmF
rudHRkSett3X2v6N0POOvAoh5IVb7k/V4f5YhkC93NWjl8eS/NDDcTDG6dv7uKid
udn4ngBV4kgckPufmCtQ6KVsze/Ga2Ajo3pe2LSqYy64Z5xPHttWMsoQqYinUhu4
GM4bTgPyg9dC1CQK5ZrZcordXetB+O7uAztBkpZfry6QoFEdN2CDoVNR78PJR2h1
vInS18SDi1rr/Vn+6BHFnJ4yips9Kl6E7ayJPrNoEt/sw5QiWdRsb2M8roEgiAud
1DkT4cLhbaz1o/jH5t7Pjb8USdsN9OfJsu61DhmKVQBctHc9GIOjYNMKOEFD0hWF
uel8E85NUfIDjpbcsl95f/Fl2R9ZajxNSdk0LSE0s8+ZYOs64AeI3F4PwlobDMCK
R6T0hE9EpH4tZWimLXMlVn/f9dvsnoXGSLD4gjrfnpxNWBPgfPBJ1SWKioGqDHB0
RcTYptxVelLURIeJx7FikLr04ElIHREX2seTRSNpI4CPJAhmjaQSHt1TDWjtcnK3
SOETCNRwNFM2Xsn5MHwaN2bgqu+yQpQETySGR630AHhRfuZM2R8g+9VfLjJSDu3G
kUY6EXlaidYRTXZSqTuOwyz98P40fbijfZkYykekgwqv9w==
=d1dZ
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--

