Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1KCXMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:12:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45670 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab1KCXMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:12:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Date: Thu, 3 Nov 2011 19:12:28 -0400
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
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com> <20111103224452.GS12913@n2100.arm.linux.org.uk> <201111031907.46434.vapier@gentoo.org>
In-Reply-To: <201111031907.46434.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1436663.HJnIWhvqZU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111031912.33040.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1436663.HJnIWhvqZU
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 03 November 2011 19:07:42 Mike Frysinger wrote:
> i'm aware of these efforts, but i don't see how this Kconfig solution gets
> you there.  it's still a single define depending on arch-specific knobs.=
=20
> now, if this were treated as a max value that was based on all the arch
> needs, it's now useful across SoCs.

s/arch/mach/g
=2Dmike

--nextPart1436663.HJnIWhvqZU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOsx/gAAoJEEFjO5/oN/WBvwEP/2BOrHVDTP0ctjIWGNSMRRsE
f3Wv0ukiY1DHs+1wMJSLzfGIqHsxtZ/FyJR7cwNfXRRlkgaqy4huO0HbtOf8aYl0
nS+fWjq9KmBC2bdr1jKNxVAJ3dFzjXTdTS0F3+dXsdL00lIUA1xA4t7SoBDgOvHO
2EbnuEYwjRspRGZyJQ6BLZj92NxjrQKQx1EaWOe7qQ+JlJuCNcLl0zTFFH7qAoRr
pkf41Lg/9L5MmiYxKqbKmCz7zUr9rGogXu3nJ1GU0WfWGpJ4A6B3aQZHzzWHGKtI
dLOhX8RMP+Hxb3gtF+xauZ8s7yJSx9AcGX7R3VPLLZtwyvH9MdmuVJXpbnGMOfA0
Sb8n5W6/oU6mgP7V4+m0C+GMDAJ3Yb0TKnO54IRoOXRZLZGFfI5asVdvy4Aebppc
SV1pyaZXEX4y4zVJuieIEhZFVccKQH374UFH4i0DZJaOQuztvk3D2tU2QxirJlHu
J/BPDo+BAJnkXv3w4UgTF2hAB/CZ/9FTkzaBrbh37GPJebyl2gyt2wIkvkmF4gr1
Fptm21lr2zb2Q9a636+W51RLG6KfDqASoq9vH4fr0kgYIymspgsXsqzksuwahO8/
AoRGdJrAM0M9lqKgh5uZ5fJbToruuRexmGecKS/F6X8QSJZqk3iRd/9tW3arkAhj
Nx+0JlV4iXBkIxSSCjyR
=VaoW
-----END PGP SIGNATURE-----

--nextPart1436663.HJnIWhvqZU--
