Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2KEHds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 02:33:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2KEHdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 02:33:46 -0500
Date: Mon, 5 Nov 2012 08:33:40 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: Pinctrl-fy
Message-ID: <20121105073340.GB31066@avionic-0098.mockup.avionic-design.de>
References: <1351699047-4487-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1351699047-4487-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:n15iPlYymnxMsQbQ9LI5EkHKXG3s6FIaW7Awwua0iZj
 vhIUJ6q2DtKEp3pKQMCYVQFxCmmOSYb372lGUmJ85YLGQ3dSoP
 nu56QLs6zARin94Vp2D8NxZhV2y3yRitwv7hDK0qd68Twcy6Ij
 7OItkqMBDMs3fqFUwheYJtQi2jJl7tz+y9f9kG14vxJMNExqqb
 llML8mmS4zjv29VQgrTSRrz3C37clF1bPyITkTq+W+Tr9E57G+
 Ehm5IivWL+WlXAXs+Vh8uQx6jZf6pWnOTEBXLkI6nZnOyqVOL8
 DT2lKQovrPsEtqZ1sXqOBdjOT8hdpCJ5AKi0UYpvlEE3LWF6Fi
 VwrC3temhLBp9XG16WnsQBrmy5ulptDCznFeeNcCA2yDk+UBoQ
 AEBV1vo3Q8nAcypT4UBL+ckKHlC3vKEB/CQ6uKZZPrw22roMJ3
 yDbPn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 31, 2012 at 05:57:27PM +0200, Pantelis Antoniou wrote:
[...]
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
[...]
> @@ -20,6 +20,8 @@
>  #include <linux/pwm.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/slab.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>

linux/err.h is already included earlier.

Thierry

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl2vUAAoJEN0jrNd/PrOhs9UQAKTLhWmRZv9G4qb1inwhHYVN
naZBCm/2l0REuzcTsYWVWJcLJwzLsI8GU7I0nH2rlJwUEVwPHqPgL2DcT9+IRZ1d
yZuIORTwgXai+litSt1aEnWXvRmB/sYL/Sp4YLP6GcxJ6hwtI89cXDu9nI9UajOP
qX4TM54fNVfSjcMa6B1v6f0Imq6Ign8FMjkIKBfGmFKUK+Ngg3Wa2W0i61Kh6lZ5
xsUUgbecL25QjuC4GPBVYLquzclAl24B6OG8U028OgrUn846J7xIrcHt/lLFqiR2
KyYAPYedBGjwyZdGE/F5TS+OLjRBVVLOmW2tenbinL3si3AeUi0bm1v+MIJLmogI
0YsVg6W6bz1G4mBYxQkeRvxTiPAeHKhsFJU0v5ocjaFFNGxoEQw60ae+c8J6+G4F
kJVfyti8pu24EqFYM66YJhwUcmPWLBA713OwQxi5QslzrXxnIJmZiuRftCsgfvED
rhtQ9dwJgBgqEbRojPO52r5Ty+0EFBQtYh1gk0w5t1rq0XpdG5MwfHrlPhTX1P/f
Hbawe2DOOyPbPBWrJpeugr4qROMOLud1Bkxo3NzrwXr2ELG5m0BDxdrs4UTeQoUT
fHkFg1avKkXtMPShox7a24/cKVIaHsDdtturFJMETmBEKhIzHPgLiNOr0Ymc+80D
GkU8WKMcKaPIykRFZdJy
=4cFD
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
