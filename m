Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2KVVEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:04:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65526 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab2KVVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:04:47 -0500
Date: Thu, 22 Nov 2012 22:04:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 07/11] pwm: pwm-tiehrpwm: pinctrl support
Message-ID: <20121122210432.GE16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-8-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-8-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:tFxJD09O2PufQFvHqs0IrXTzteOTmn4WLQ7lLXluBeM
 4WqiGGYJ6zLuRJCR/3ddhd9jq2X30ElvlNDn3Eh0VEuyJkw0EP
 MhWET8oqDLgc3mjoIX0azokn9orXBXPMenHb8ag+jwT5pegl7b
 LOcBMeVI+ERYJPXZaz4sTbQZMS5Lv+SHBbKq2sVDfU4S/YwOLv
 8VpqqlceruYL3HsmjN0w/W4IqCg6YKIg0oU++V1dVqUBCIcd5b
 Np3c+aeLad9X428NdpjAeAY7OOwEhL0eQIbFX+hJ71pPsz0pM7
 bhVB7P+hBd4tVealcOegb1NkOqt270i1HS6TQUVUhIF0DTSTM+
 THDSacsNrIuRReIztQyI6pGuvjMQDqX+5Xkve92e3ZlQfhieDn
 TnfVduV2rRQDn0AiYqUv9n3JNOOkSXfk+mQtl1YB8GSsK0+LqT
 /Q88q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 06:41:04PM +0530, Philip, Avinash wrote:
[...]
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev, "failed to configure pins from driver\n");

Same comment as for patch 5.

Thierry

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpNgAAoJEN0jrNd/PrOh8hoQAK1okFVk06Y/rIQ6/Gyd45Yd
pWNCh8L2I9PKJ2E3xYkhR6EPlExITW+3Upw7rtpgON4mem6QibzG/gyEPc+5pyQ8
AZWfnM0FSIG1dRU+6+zVJFLqdPvoR4EmJ0k6NJj/wbLrDKg9A0as3xjp73MRvw7J
YkMss1MR6XQIJTojf5Widcm/AZKB/XuZblU7EujRAdxM4CCK58fStk9KWWTxFT/+
IO8iSScctteUYX5K6x1SmTvM/QnEjgwj3goCY+JXIaIOHtKcQ6LcdMs6K5w6h5Of
wP1h1LjGHims7NCGqtZ/h3q6LReyjUhjUyQJPITVBcW7iDWM/DMSh9vEjOlKzk4p
qOO/WUB+lB//vadYdsnpjfVa8/eXCD3pnFPacdX126+8UjfcLVT7nMJ20CJEIVy2
Fs7eI7fl/gJJOqkTpcRct3GU2fLnaxf4+2vPhmAlOM10I89J/7sukZIzMz1m6PfD
RrHLjeBGSSDs/p5Z7q/B1WdDpR/eW2AF7OR1mXjYnDWPEFzAk1WbwuV5i52XMl9H
tokvgd7SCRU8LYttcLEJRoSeC0PnYDybpxOnI/VQr1qNEJURbS3n1Tn6yP428/U/
zRYfc99EiXdqR54x0xicebCpU+BZjE4C3PihGUmuZ73B6jxeIAguso74IGzukiRb
6VDES05+rDscYxiOrWNF
=76o5
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
