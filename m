Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab1LWWBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:01:34 -0500
Received: from home.keithp.com ([63.227.221.253]:38273 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1LWWBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:01:32 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>, Eugeni Dodonov <eugeni@dodonov.net>
Subject: Re: [PATCH] drm/i915: Disable semaphores by default on SNB
In-Reply-To: <1324675987-31033-1-git-send-email-keithp@keithp.com>
References: <1324675987-31033-1-git-send-email-keithp@keithp.com>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 23 Dec 2011 14:02:42 -0800
Message-ID: <86hb0rndz1.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Dec 2011 13:33:07 -0800, Keith Packard <keithp@keithp.com> wrote:

>  	/* Enable semaphores on SNB when IO remapping is off */

Yeah, the comment is wrong now. I've updated this too:

=2D       /* Enable semaphores on SNB when IO remapping is off */
+       /* Enable semaphores on SNB */

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvT6gjYtFsjWk68qAQhALA//Z/NKOjNawlowhErsDZvATBX7Nw096J0P
bMoCUzyZIK+Axrh1Bfs86v5TX4Egm20X0SA7CWotYphQDe4mHnSeojZNLN33/X8i
CwLL+rFatwF5/UGqlstC3hi7ciCOM4E0VsrZnBcUSENAP1uPJ2ISWcI5b/RG6UpI
H1+5s04scRyTnOkTgtWxxB6Dc30OCpuBChGGCb+Qbide+qMqN0kuhGChKnc3LuS1
oWsGNEnyqFfqpGBMp4jf8CWjnMGFi042k6e3UZuLkxWK9fRKd+o83Dfri12PPXmE
dKAB2+JbDvceI2EwOatftj9UqcCSWse+fR4ikCcYfhl8EaGYV1fIaMqb+Hu4B4WS
ItiseUEukqMHadMIh7AyKD4sx2F0zA2Tsp3DOdSU/PvsjGL+KU05SaXCKiDb3vCG
NuZk6RCwHkCpe54FhokasssILARezJchaOKhdF8KhmGJ/WqH5ovjEfNya//1ADKX
+8efgYFbEqurOMw++1QfCKUdDfmX/YUAj1ErjS10axVg6mcQTLrfukQ3d+ihYS6J
9wG5R/3qg5RibF/4CWhEc8xTiH1CITQ26hMEWARq5CgQzk+FV6W29R2dR96VJy0B
AyvHtIZCDbk9iCP+vdPjehfCYyxMVUhuAbzfFH46OUwIHT7AflJHgIKeixjfmGqh
YgFiBV4LAeQ=
=WuGu
-----END PGP SIGNATURE-----
--=-=-=--
