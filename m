Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1E3FBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:01:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54836 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1E3FBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:01:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [PATCH 3/4] clk: Add fixed-rate clock
Date: Mon, 30 May 2011 01:01:23 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1305876469.327290.592839707336.3.gpush@pororo>
In-Reply-To: <1305876469.327290.592839707336.3.gpush@pororo>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1617968.9BoLahCQfk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105300101.25264.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1617968.9BoLahCQfk
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Friday, May 20, 2011 03:27:49 Jeremy Kerr wrote:
> --- /dev/null
> +++ b/drivers/clk/clk-fixed.c
> @@ -0,0 +1,17 @@
> +
> +#include <linux/clk.h>

missing intro/copyright/license comment block at top of file
-mike

--nextPart1617968.9BoLahCQfk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJN4ySlAAoJEEFjO5/oN/WBBVgQAM0t3ePkNJygtGDX64xynYMl
+duC01Lwp6WOT4CY/52heu7IfCqJ83g68XFGEuz8LURRmIaO1vwTDZdx7c5Nly7i
2QP2Wop/HXAkswkCFar84LCZEPGNcFMrN5WQ2fmdBsfFYrXVxMSCrVuAQSZi5fjF
1cOSD4a2BMZzZVrzY2c4OmHEXmRgeP8p4/W/pUXRUbd8qV2ddMO8eSKpLof/DMxo
GedCpu/SUQqkafYEPv+rzy3eW7WA6Am7oJofXSyNyp8NjFKkr2dycP/w18XtI7VG
ONWnKQRTzWBrv1775BIDgMsc7zu9/fgfcGRUwX1/fYkbbW84r1r5FSzwDW7/ddLM
N0SGQPGRV/TMxbql0UnLWo3/+Kh+OZxxyVJxj2Q4WgSB0LwmagK9hIDa1Bk0XhLL
GZ6k4Szv7RtU1SJSrjDVKN420+5fQnR1b45JT8XZmpajLpXuu/rTO+QNaq4YMQ34
IeIoq0bo1pNjwMgg5TEFJ0pQBL2v0MVuJQjgjYiUiyFrpbOLijJ7PDotN39v11rE
CKz9DAfa7ZTPQA6CzYTsp+ZtfsBexbRFveHEbtEfJg9m0v2H/XMRGrjxdoAF0hVT
5yYNH7otzVJfmQM1G0BJBByiOIbSnnrig0Nk4+g5YkScxQ4UYcbAYtLK2Dx97X8P
Lv3MTgPd6wPNT97ADjUY
=QWv3
-----END PGP SIGNATURE-----

--nextPart1617968.9BoLahCQfk--
