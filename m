Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2KVVAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:00:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2KVVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:00:00 -0500
Date: Thu, 22 Nov 2012 21:59:44 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 05/11] pwm: pwm-tiecap: pinctrl support
Message-ID: <20121122205944.GC16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-6-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-6-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:w5aTnYZrYkw3lnYDTUu1C1jVrF6OpbbGOv8b0518rtq
 25n2VstPF+m4F4NNo6KMYLH51/+S8YMWcMN6grh5+yXhyYP2oC
 euKpugVC4wwZQxPtLfLZ2FGsETvpLjWRThdl6k8NewCEXS3rQd
 2hcRSrnGZAlE/FZbpoimb6TEOxajuGo7yKNmiWD/vJFSBT3V4y
 S1vMFpCugXevI7ETMmQh8S1NOAhAfCVBRVwoPTOvlbsBzbOQn/
 +t8ZyKBqm6eDohQwr/w+4jI73QSX1nRJsHK+94yc5wkV0zHDSB
 bLu9D/vlfCf/AfkwN2tNYYiOmkQzjKfJbMFCnQJCroHIn0JZzo
 VC17GX7GS0AJvNUeI1CvIZZIfCeZyr5WKvEt0gdLUjfQ7LuXm1
 IDcsb201j6xZx5xfczY9qyr7jAEKapN6jA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 06:41:02PM +0530, Philip, Avinash wrote:
[...]
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev, "failed to configure pins from driver\n");

I think we already discussed this, but shouldn't this be a fatal error?

Thierry

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpJAAAoJEN0jrNd/PrOhWpwP/iUHHBVkmCk5Chr1iJN2CCjy
hr2gF3YlBQpHpyyvH9+rqtkRzJ0+7iPvq8gaM3pQoW67lgrD5H7nHxqfCqdxghV2
8ARiatAsfiWHAhHi/O9uNCkJ+NZv9YyPaPsrkJvaSie+O14HEAM5kiHtDOpFDkkd
STfXFUHIgMtajNMo4MnjON8FTr7dLv4/RmXVymeUskopkpYoD/hvpqlg1ivEz0M6
UKbbPZ6Z6iiLp5wwGYBEN8dhHA7uHqjFmRfu4dDdD8tKwMLxCVN6EA539VawWmeU
x2gjBbE2Vi5REBt8G+gDkJqCcSB46Xqzg7beZSb7C96bPuxFcI1cWZKzGnjCeyfM
pACqZFHbci8+9hqWYkhAJ3PnCfXn9asR5UMfiwVUxRG7v6LaHPzh4dYpNeW2bDGB
E2RCC2AeFKJ5SqsmM/YOQROHS88RDAFBaXYjly4kPj7Z9dNI+pgoPMVJg3B+tpMI
Ob9NNyYXP+NNOedGrBYdNhnj8Z+51aYMtKAG/KWYyga4U+1JkHEmIQ2BpAfemh/u
WMNqWVSFA/y8hf2AT3PH9Vq0GgfpqfOrOIKZLnwdIAeIl9uEDwp0phDMGkB6Nnwg
ckGRHEo3oQfMzACNUjuXO2vX0TOIig8+rFrThqotrGP+z3wTZNpjevkC1JUImJp4
9veop7y+AI0mSrvAqmru
=7YdN
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
