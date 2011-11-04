Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1KDCF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:05:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56649 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1KDCFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:05:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Date: Thu, 3 Nov 2011 22:05:52 -0400
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com> <201111031907.46434.vapier@gentoo.org> <20111103231707.GU12913@n2100.arm.linux.org.uk>
In-Reply-To: <20111103231707.GU12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1345463.Wp6H3ntS3T";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111032205.56557.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1345463.Wp6H3ntS3T
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 03 November 2011 19:17:07 Russell King - ARM Linux wrote:
> (b) that's effectively what it is - if you understand what's going on with
> the 'default' statements.
>=20
> For any option, there can be multiple 'default' statements:

thanks, i wasn't aware of the cascading nature of the default keyword
=2Dmike

--nextPart1345463.Wp6H3ntS3T
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOs0iEAAoJEEFjO5/oN/WBIeEP/1Wyyp9+aPLPgLMKLoG3XYdj
VYI6vVKkcrki9XzC2iKlnvm6cDuXAvDX8aQ2qSC2bgcxjtmv8NgkMpWUiZS842zb
xfq830kzib9Dz/HW3p4BsszAsrO5/Mvub92ZdS+ykiehRL/QhxuC0G4CaClNMYpK
5qjBy20wVUBc509dHEz44agckcnptRjygnhZaYLJ3bpmeOEGhlehnhEHPfOK1KKr
wt+deV+lUyqjBqavSLOhN2IF0dkZsXqYmCTqlHKuvNE+DYm/POTGnf0MPerS6+lX
RKG3E8yjBRPsiodNlVJy9UosQ8LCFc8bYzHAfn9a53GetYKHS0cc7t6unYqJ8/6v
yyVRFkdF5fIgkmWuqIfLejQGV5hmJTH95/szoA8faCwefRmQwl8CGgw+4ZlSAHuz
RgiVPoSCv5lo+QOOHlkD9aJyfsKTVcJ+DCvoD/uZQhsCO8CHtINxNQ3TVi8Q2BRA
bOw7xRpvyVVe7TFOjdOmu0lz6OX9Al1ocTuo7SH2Raz09crrS9J8Zbvk6EK66BuT
Hz6H2wEpGaslLW83+Iy5oRs6HXgUhDKhPTBUVUwnar8CnOvWEhc4MuAfohDU1OvE
42uauV7WX91OSADw0JSH9sMF6z3xjlXH/Wu+d01q8mdxbHHWEVy12BEtp/vUvDIT
n1ZxN98qSeeQinnlbtnw
=YQiM
-----END PGP SIGNATURE-----

--nextPart1345463.Wp6H3ntS3T--
