Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1HZTAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:00:03 -0400
Received: from gold.linx.net ([195.66.232.40]:34544 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab1HZS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:59:59 -0400
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
From: Tony Vroon <tony@linx.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        suresh.b.siddha@intel.com
In-Reply-To: <4E57CBBB.3040806@zytor.com>
References: <4E579397.6010009@linx.net>  <4E57CBBB.3040806@zytor.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8SZjlmX8PJGyKXG6HgrY"
Organization: London Internet Exchange (AS5459; LINX)
Date: Fri, 26 Aug 2011 20:01:55 +0100
Message-ID: <1314385315.8356.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8SZjlmX8PJGyKXG6HgrY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-08-26 at 09:37 -0700, H. Peter Anvin wrote:
> Hm, I don't see any evidence of the MTRR sanitizer running at all...

It is almost as if it failed to find an optimal configuration; does that
error path not print anything?

Regards,
Tony V.

--=-8SZjlmX8PJGyKXG6HgrY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEUEABECAAYFAk5X7aMACgkQp5vW4rUFj5oCpwCYgm6/q9PhjyOr9xwmdLP0XN+h
oACgvxARDVW9iYRGashI/L0gbEPBfWM=
=iaA5
-----END PGP SIGNATURE-----

--=-8SZjlmX8PJGyKXG6HgrY--

