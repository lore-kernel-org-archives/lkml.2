Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2AJBPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:15:10 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34008 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab2AJBPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:15:07 -0500
Date: Tue, 10 Jan 2012 12:14:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: more PID churn during boot?
Message-Id: <20120110121459.6b358afe6052810e91dfdd47@canb.auug.org.au>
In-Reply-To: <CA+8MBbKKTmZ2fD-j0xnQuxDh9jBO8jfV=gjP2cVvuPZg4r42+Q@mail.gmail.com>
References: <CA+8MBbKKTmZ2fD-j0xnQuxDh9jBO8jfV=gjP2cVvuPZg4r42+Q@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jan_2012_12_14_59_+1100_ZK67iUrQjg8r0nlo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jan_2012_12_14_59_+1100_ZK67iUrQjg8r0nlo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just adding lkml to the recipients]

On Mon, 9 Jan 2012 16:32:56 -0800 Tony Luck <tony.luck@intel.com> wrote:
>
> Just noticed that linux-next kernels from late 2011 threw out this
> message during boot:
>=20
> udevd (124): /proc/124/oom_adj is deprecated, please use
> /proc/124/oom_score_adj instead.
>=20
> while the 2012 editions print:
>=20
> udevd (341): /proc/341/oom_adj is deprecated, please use
> /proc/341/oom_score_adj instead.
>=20
>=20
> So we are somehow burning through over 200 more PIDs just booting the
> system than
> we were last month.  Anyone know why?
>=20
> [This is on an ia64 running a SLES 11-SP1 user space - hence the old
> udevd binary]
>=20
> -Tony

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Jan_2012_12_14_59_+1100_ZK67iUrQjg8r0nlo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPC5ETAAoJEECxmPOUX5FEnsYP/2V+n+FPVz8O5R6ODqIUwqRr
TNKB1IuMMyncCx0mTQwL9LNOqBclOsZYOwmNZJCCnLloMcEOIVVWfJbeORnNn7L+
NYyYwLDErXSP75XdMwxdP5K2mspBnkCVNDayQRW5Qu/d4K43ud3DR8tSkotNKbT6
Y7RicaGyMXFjXs4LOyJUvprPx5TTLzQsjcBG1iva5hBJP3TxzzkgTZzacgaFzUUd
hfGqwKqzTBWhLtdQHumMfCeKG46SCB6IN9gGzBLmUzSjXt1n2A3NYE0NWajehmkx
Ui1gK4spF+s44WlhosvaOF4l9a3M6A3WElvqzp1tjkM4MLMQAINWx5UuWqLw/ac4
vi6Z7HWY7UyWYJajCVpEmzsmtYJ/KzxplM6w1Pr9nwv8eGDx5/9y3vpLcKFFEHpU
9RSDsiyIQpZdT/85lySJy2Xf26E7jJ0HutZMTwNhlMenMlC+BB95MleehMXR9MLZ
/Y5cQ6jJeoXAoEqsh4/IzB118vmUgxmT5b9G6IvjvvqoddCiTAyLIxRR009iehMD
28o2P3InoZCZmqEy3fNpDs7ghjginosZLYN6i/GPS3U06Bkrpkm1S7tTbaqmNdNJ
mtmbLevpA7HKHsq2wHwVuB4dOzVwCuL5tKe3+ahLEQ6jmw7JZSfjiBEaRhKGJ9oQ
6jhB0lQRnge+gvsw+VLZ
=Cvxt
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jan_2012_12_14_59_+1100_ZK67iUrQjg8r0nlo--
