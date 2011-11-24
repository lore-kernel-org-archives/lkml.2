Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1KXRce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:32:34 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48669 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1KXRcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:32:33 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 6/8] ASoC: SigmaDSP: Provide diagnostic error messages
Date: Thu, 24 Nov 2011 12:32:41 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <1322138908-32127-6-git-send-email-lars@metafoo.de>
In-Reply-To: <1322138908-32127-6-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2918387.Ott1kBgXoW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111241232.43809.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2918387.Ott1kBgXoW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thursday 24 November 2011 07:48:25 Lars-Peter Clausen wrote:
> +	if (crc != le32_to_cpu(ssfw_head->crc)) {
> +		dev_err(&client->dev, "Failed to load firmware: Wrong crc checksum:" \
> +			" expected %x got %x.\n",

it's my understanding that string constants should not be split
-mike

--nextPart2918387.Ott1kBgXoW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOzn+7AAoJEEFjO5/oN/WBZ4YQALkPFH11yape78gS5ndHPKIh
KhZIt4z+Av4eL1jeRf7TVcwsaZ5Xcfc2sEbwtSrHXPug9TgAI8bFIsxa7H42mnsF
DOB5oVOQZ+yGGviUkcgyDkuzeuoj4NJvxFl+WGYJRnJpo4shwx0WCIPA8tag9fI8
AKSXLahEWznnN4Q22O62jgONzsMBJV+867VXWrTLNsNoxmYcY59lw4l4oqOiykix
Y6vYPPWitIeK2z6HHXDrGv9/oI0TjlpxLImfRUjE0tT+n0E0mz8U3WXgtSpmlBgx
tljPnjzuTGenWknpSsFxglye8BzXasHIMlc16egoNSqDzDzb856SOmYsFgiLewK0
jt+oD857X6hAugJUmJ4Py42aq4X8STTbH898c/rBSygBa41whZMTHhz44iHQAFg7
7Bii9mYh0UwpVK8bTbDF92uaVglYnbal2/JzOMMlkxWaM2fE5hmv4frzExI9n5mg
H0Hx9f3A4dLJKwcwb9GuLxPL38JJyJRqBEJI1Xw0Y7312xqZptPC4xPZb0uxVKpp
id2jJCygjnpdP/XUPXVSHz7Jt+5nN4vrPZsGu6k50OTtY6lBacJ+WPxmYesE0lIe
5wMhBrqUchQupfMXHCcCyp/BYnNu/l6uyoFFnRBG7wpWxNCBwRHk0JpnghoByEdU
VyPfYKYAnEa2bh34mHUM
=2bQc
-----END PGP SIGNATURE-----

--nextPart2918387.Ott1kBgXoW--
