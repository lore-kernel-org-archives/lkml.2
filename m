Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2BQMpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:45:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52589 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2BQMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:45:22 -0500
Date: Fri, 17 Feb 2012 23:45:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
Message-Id: <20120217234508.8293a84fb3ebb7fed6d60ec3@canb.auug.org.au>
In-Reply-To: <20120217120815.25909.15632.stgit@zurg>
References: <4F3E42E0.4030108@openvz.org>
	<20120217120815.25909.15632.stgit@zurg>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_23_45_08_+1100_i6_Wv7IGwEldTbpZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_23_45_08_+1100_i6_Wv7IGwEldTbpZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konstantin,

On Fri, 17 Feb 2012 16:08:15 +0400 Konstantin Khlebnikov <khlebnikov@openvz=
.org> wrote:
>
> Config NUMA must be defined for all architectures,
> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
> Some arch-specific Kconfig already has this stub.
> This patch adds it to all remaining.

Why not add it somewhere generic (like mm/Kconfig, maybe) and then it can
be removed from the architecture specific places over time (if necessary
- I am pretty sure it is ok to have it there twice)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_23_45_08_+1100_i6_Wv7IGwEldTbpZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPkvUAAoJEECxmPOUX5FEA04P/jlKqTYcJWbQmb68/1L+0b6o
M2iarnKw3wiqHYfDxO+7+Dn1VWAGkPWeJymbNi7qcM8BxwOVJo6EcpZRb2UIyQXq
khcKZCyIx9kIHkS58FR5pn6H5rtpaaSq4CKtr/29i348Sjhq8LkPsZpKyZMOBcwI
Ni9BjU85j78qIg0wnObWAxg3VkaVfx/YdiApMFp3duZfFHOmP0Cpj2eytWs4JsZ/
LAyjZM/9RSwRsAtvgPi7Y/J4hnfvO6qbO0u6M4PfgU7Jt68KykpI7lkocPjrS7nb
0/x7oU6RcE5Z7WffEBIiDZHCcpIP3p+pg53oEBHpq498yKerR2cu4VpjBbffEowk
nyYKb1+L9z+kvpAhHkBjtyORdO+7K51HBEgqp1M87C8GN8sFClxJxxPAxZ6PlbtK
Ho0RszD/0irnK1BShJmxQuChr03IxukPEGLRbiFkZuevJY8ZUvG8wKrZ8wXe6/Bz
hdkjBMnawmsAba4OQqIe5DO8ySEGd80kIRbg0DgUVOk9+D3mS8RkrJh/IeU6JGGt
RVi4SJAcuc3JYjg2ekSpT0YEO2aJF6OaLNHXb9J6bF4c7ClImiBultBTEBTW6Q3E
2rPMHmt4JUGlR+kKa0tegIHEO+bXEVrE7sjyJPHsQGknA4Cn/EhQpxUSP3PaRWIl
SNlIi12VAAXqRLsC9rke
=Kxgs
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_23_45_08_+1100_i6_Wv7IGwEldTbpZ--
