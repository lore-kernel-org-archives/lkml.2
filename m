Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2HIFl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:41:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2HIFl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:41:56 -0400
Date: Thu, 9 Aug 2012 07:41:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Philip Avinash <avinashphilip@ti.com>
Subject: Re: [PATCH] pwm: Remove a redundant error message when
 devm_request_and_ioremap fails
Message-ID: <20120809054142.GA29806@avionic-0098.mockup.avionic-design.de>
References: <1344001434.25906.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <1344001434.25906.5.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2kBJZiGqbaaVSvLzlyu2jbjfPE++bmFoyvInKXxfplq
 wj8ywFt39NQ4DrOc5GCNol+C/luAVOwtFTekYc9ILwcqZxokBc
 dBD7KWfXx1StQoDtpdgXCX/6FkMwysVw+eZzTmFy0ZBEOOR9Io
 PAbUD1ho2KttxEqgy9iNTa7OgTFL4VeDYbMfuKwL5ryJDcjIRz
 4fA0prLBggnk2R53R3L5lW+0J7YUubffE7pfI0pECHFBjTNwI7
 /U01sWRBUfAOxWZw3IkenZv7vGRFKv/cFELPwTg5s3p0TkuLws
 I7vdZUq18+Stp2v45yiBixufuWP+dCZFmamvdHnAEgSjVYHmbt
 uL3yR5cTIXjjdZjXjfEvivVohviFnB2saYIIy6eiyM38hLDkpv
 teOshqceklk2nxSrldmPiqa/2Ub/YV1WF0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03, 2012 at 09:43:54PM +0800, Axel Lin wrote:
> The implementation in devm_request_and_ioremap() already shows error mess=
age,
> so no need to show dev_err again if devm_request_and_ioremap() fails.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Philip, Avinash <avinashphilip@ti.com>
> ---

Applied, thanks. I'll carry this in for-next and master. I collect fixes
in the latter and plan to submit them for 3.6.

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI02WAAoJEN0jrNd/PrOhnUoP/jpS5fDkc3FGMePupcTuD1it
BkAgAQjIFla+ZQmYwK1iqUHhTIJ+OudCZs+LZgIHHFwXPG1okqLuowGt1sUuBPo+
9UHRCm37DBG6ng5viLXtY4c6X7+Sulr9aoVSvbxFniTj6h7HsP03pf0Vj9KIJ70k
UAdL9lrr+qNjja9K8es/0LGynXUh9vpW3X8ywKgxmYHzmxepI9VuuKiNwUMSZLTz
l+okxzDVWmeX2AXwcPiygGdb3Hjh7C5JCOwrVHLxQ6mZjAxsgE3H4x3LZbnQEQjk
K11UIB+231OWL498DEqoHhvDpa7lMdfwDU8AAGD19RnFMKwPTYS/DnpSSYrgTRSB
OC/YoxuMHjOjq9AjGu7LG+b1Q+UzLTNzMu7MvODmjo7tR/JJ5AXKQXXLCBhyzBHZ
juSVZ19verCvtm5jUSOKbV3qEwp9EFtYPw/pTkt0KdtTdpcvwKG52sI701+/RtPF
VLal0n8bPcYemoaVUFvz/aRQpcvouMHPlMatfFVIT7FFb4oS41/Vu+HFPma71ClQ
UML/mWOrfEQ7kv2nV7oxLPn8xE/FGFpOvP6bcd8PsdVv6NUST8qcIxxL08OrjzDA
DIFsbHcoygKz4lrGIT9O9OZLipdC5Tq8IEHOf+Wp2s4Jl5Xu3DnB+aoM9z/YeO8z
B4dlCo/FUsgmCAGiuOjh
=J6wv
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
