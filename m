Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab1KCT5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:57:15 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36194 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750925Ab1KCT5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:57:14 -0400
Date: Thu, 3 Nov 2011 12:57:08 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 4/7] drm/i915: Let panel power sequencing
 hardware do its job
Message-ID: <20111103125708.476af3b6@jbarnes-desktop>
In-Reply-To: <1320214830-12696-5-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-5-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2f6fIRa5gqC2O08d9juHj/W"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2f6fIRa5gqC2O08d9juHj/W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:27 -0700
Keith Packard <keithp@keithp.com> wrote:

> The panel power sequencing hardware tracks the stages of panel power
> sequencing and signals when the panel is completely on or off. Instead
> of blindly assuming the panel timings will work, poll the panel power
> status register until it shows the correct values.

Modulo what we already discussed on irc about the PP_READY bit, and the
CodingStyle nitpicks (newlines before {?  come on, this isn't X :),

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/2f6fIRa5gqC2O08d9juHj/W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsvIUAAoJEIEoDkX4Qk9hDKYP/1ZgRs/x6MK/KU9uJyJ/jeYa
UXs9AU8pXK48ZfiSJ8BZf58Ji/FQsXQRQyoCBjrqrdKkHzxYl+djcLu3xnhdQdvl
KfWP0kv4R6LWuP+imCFg0v+mzeh09n0bR77jyQM5iLBI/smNWmHkO9SNv3gPLWjp
WrCOexjBMR8AZ26HdHhlqgMyNwPO+8DLy6KqvBSRUlR5XnT1iY1haxnjYLR0umIf
q1J6X52lDiS6cUTpd461XyBXI2LmCQ0O7/MZg0B84WQr7UPXHGWY0MgQxjRsytdK
L8SWNX02ha4oCETtkbaEfRUUFJspIdEWGxTeNzwU+YR5pscyJjTlS17P5GS4FiHl
/14E7jgTdYPZGY0czKdK7a/USJi5LlC1FZy0rBsLgtVqEpf3iIjmyNhYBH4hihyh
TUctwr2KruE2Ijj9Cq4ES99saY8hoyD4cS4l9bw50fstOYtUAUEF6sJ1nwVEhrz/
DROwBPyvMm5GDTQKGPOw8hCbwFKEAL3EAuYv5G/UtwBwBIFzYHS6uNIBW1qUaDUe
2TUHlZK2bMlO04Kmmxd5/kBdoRoZTEsO8T3LuxjSvjQF9AiVO66DOOA2g92i3JG1
/H06Um3wn8jml0jfuNWnG8UT8XpcD0Gg69EQBEk9xyHVuE5CLNbxo26snOSZXCmD
R0nCnM2jdf36TOwPvoFc
=I2bJ
-----END PGP SIGNATURE-----

--Sig_/2f6fIRa5gqC2O08d9juHj/W--
