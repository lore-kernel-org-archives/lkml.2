Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab2KOFX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 00:23:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50384 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab2KOFXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 00:23:55 -0500
Date: Thu, 15 Nov 2012 14:23:48 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps6586x: move regulator dt parsing to regulator
 driver
Message-ID: <20121115052346.GF7599@opensource.wolfsonmicro.com>
References: <1350569169-27455-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline
In-Reply-To: <1350569169-27455-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 18, 2012 at 07:36:09PM +0530, Laxman Dewangan wrote:
> Moving regulator node parsing to regulator driver in place
> of parsing it on mfd driver.

Applied, thanks.

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpHxHAAoJELSic+t+oim9LfMP/3wnSETwziVkZhuKTRzxc5Al
pdS9RXnnY3noJHfC4JFhRjhhv4w/cNC/AY0ZrUWPGGO+INEbYW/yb2H/3YFOjeVF
cQnEXaeFbaD5bRSW8m2J7SWmq0VRZSI50tbmMcrlD6XgDaAyRh7sOuFH5IvbtHQE
Calep+P3TRp2EbIwXko7LMJudgEpd6Tux799wIJfYaBXhWo3LgCPCXIpFIj70OFv
pyBgdtu2anp/Wtovmj9XuKAFwx1QhOuLnVkfXFflVZhfeCtseh3sNK6gWTKU9IME
cVcoLTeC4e9pHBa1hQI8Oc9tX7ZRIgzJR4tlLsYiNrut83azU/roC5NuW/2gEp8t
GOPv+pBatdtG0fskPw3K19AOhozXshyQ5veoYA4j3jyk0avqeX9duL4xGMzxzkzi
4kuxe0g0n4YYVoJTQ+E1FdbCLXWjc9Gr1VK8V94NwD5Cmowo7+mY+qYPbjrq7Cfr
szjS8fRqhT+SSmsbh1zQH+gf9THOifrFiJZNcIwKN4fc8oVldJfdm1sEFYwNeg1X
4H80wuRHjUkVWvdwY4Jbrxnpl6DmdLKB5Wh3pA4XZt6EO6I2vtnkocZC5KYIOVjd
sw8f1FW5lXE3TxnpcjXKe/luhvokwwsTBvh0+x8OZuYqkL9mS7KuWNjBq6tgHYgP
B1Xblgv0x5TubS6nJaMq
=+LUI
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--
