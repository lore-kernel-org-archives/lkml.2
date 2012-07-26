Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2GZOW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:22:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51781 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab2GZOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:22:28 -0400
Date: Thu, 26 Jul 2012 15:22:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 17/21] ASoC: Ux500: Enable ux500 PCM driver for Device
 Tree
Message-ID: <20120726142225.GJ3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-18-git-send-email-lee.jones@linaro.org>
 <20120726113838.GA3099@opensource.wolfsonmicro.com>
 <50114B89.7070100@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gX7DG0PufVj3JKBt"
Content-Disposition: inline
In-Reply-To: <50114B89.7070100@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gX7DG0PufVj3JKBt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 02:52:09PM +0100, Lee Jones wrote:
> On 26/07/12 12:38, Mark Brown wrote:

> >>-	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
> >>-	platform_device_register(&ux500_pcm);

> >This has the same issue as your last patch...  the way you're doing
> >things will break audio on all boards using this driver.

> It will, why?

You've just removed registration of the device and not added anything
else to replace that.  Even if all boards convert to DT their DTs will
need to be updated which you're not doing.

--gX7DG0PufVj3JKBt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEVKZAAoJEBus8iNuMP3dXXAP/115NxMC9YPGEiyKwkdPCvRf
0Ghbh1Kv2AlpCc25WOc/KeasYgk08QUryvYBKRvxjZ1NpA12+XAOZXdGYD8qVgyv
EY+yRiKtib9+JsrnPpV7cLWWFUIYkwgk+xNVKwPaw1xxKUwJjUKiwu2GkysHcFET
TXj7o+JMA9Kfxa2jE3FSa/3JPXgDdLqj7+ZX4olKmIYjGKvdREMv6EuaxCxKAwY0
kVC0InBKXtmwncuQIQ2hwfcgG9h/sgh0KF13dLByEkTaU/3TveiIZvvs9QX038SX
eYc82VwRFhSXvAypRl+rQcHu6xEVlK1GHXpW0kZLqSIw0H4Euw2lmCccyhVO0qIY
spCJ4EseyOyQOyCUZen+r+wbn2N9UqGVfvBZogxMDm2mg8cahyNlrMGKcn4TJfFM
Ko4HnSjEWJIEKd23nOVC5cTyqXEG2x8aRxapZbadOI+qT1hToECZ1P24gbbwmS6I
kuPo8ELWYngS4P+/arSxx+dS5rch5tS1Jf1Pf4OHJgY7TEOAPO3MDw8ga7pa4MMt
6XavRrOV71hNshq7p0/asZdfYb9l+jAF8HXm39+o8GZCbLNVBKQZ/zzAIAhpeKzW
64CKZgRPCTH4m8LkuJ/g1ry+pzkfJkAZv9OzkjfSiUI/EiYIMTCO1tQI7YtWNCYk
xDleYooo2WUK64orbkqk
=lOaV
-----END PGP SIGNATURE-----

--gX7DG0PufVj3JKBt--
