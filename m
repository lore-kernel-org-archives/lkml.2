Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2HXOSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:18:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:46627 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700Ab2HXOSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:18:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="asc'?scan'208";a="184481802"
Message-ID: <1345818199.2848.314.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: kill MTD_NAND_VERIFY_WRITE
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, jdzheng@broadcom.com, sbranden@broadcom.com,
        mcuos.com@gmail.com, maximlevitsky@gmail.com, arnd@arndb.de,
        stigge@antcom.de, tony@atomide.com, jkrzyszt@tis.icnet.pl,
        ralf@linux-mips.org, manuel.lauss@googlemail.com,
        computersforpeace@gmail.com, mikedunn@newsguy.com,
        dbaryshkov@gmail.com, paul.gortmaker@windriver.com,
        b35362@freescale.com, scottwood@freescale.com, jamie@jamieiles.com,
        aletes.xgr@gmail.com, u.kleine-koenig@pengutronix.de,
        s.hauer@pengutronix.de, shmulik.ladkani@gmail.com, nico@linaro.org,
        axel.lin@gmail.com, rmk+kernel@arm.linux.org.uk,
        ivan.djelic@parrot.com, leiwen@marvell.com, hechtb@gmail.com,
        laurent.pinchart@ideasonboard.com, julia@diku.dk,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
        marex@denx.de
Date: Fri, 24 Aug 2012 17:23:19 +0300
In-Reply-To: <1344998325-3279-1-git-send-email-shijie8@gmail.com>
References: <1344998325-3279-1-git-send-email-shijie8@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hT6WUK0bwfZaL2w8UGUo"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hT6WUK0bwfZaL2w8UGUo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-14 at 22:38 -0400, Huang Shijie wrote:
> Just as Artem suggested:
>=20
> "Both UBI and JFFS2 are able to read verify what they wrote already.
> There are also MTD tests which do this verification. So I think there
> is no reason to keep this in the NAND layer, let alone wasting RAM in
> the driver to support this feature."
>=20
> So kill MTD_NAND_VERIFY_WRITE entirely.
>=20
> Signed-off-by: Huang Shijie <shijie8@gmail.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-hT6WUK0bwfZaL2w8UGUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQN45XAAoJECmIfjd9wqK0tMcQAKMgHB5HxZLb2D0P6W1t/Kfq
72pu2CGopTqDIAGDfXGZk6eWnDbQ+NMJbf3y4pCeZEGlS2t01Xy5TgOmnIazYzvK
fHKSIkbwYE+y6f29jI5TBoRs/VfdKmIdzyjfYAgbO/jfUkG2iAXUX1YaULX2e6yI
gTZRaH4pFbw7SQKP4G9rWEMl0kapQhEf3QceQywneFf45yf0coV34KkB1GzXsepC
6BSEPRnKxjOOyOHWK/BCOvFrkeb3GRnS4De+AdohDvTcignbcoeTm0SVgGOCFRgu
FB4AV9njDiN+H3gX9IVFJ/uVYMQA0FEEGIgXReKfa3aya3MnYNdc7qtljUGLmLWT
dbScnd03Cx3V+Of+6d6wOKDsI+uiGMq/q1A/bLJ5smeh4hvf5ki+ITEZxhCPncJf
SF5fv8QjcxzzpkdXSwpRtbEfRL7CCcZ9e0jDAzsPqGXsAsiXDDo5PO7FJnC+OlOv
LvR+0WdC7K4ufqX94ozG92pp+A2ZPtd3azmcfYr0iIVNUnw7JDfG1pejPPPrTP/J
gVaig7aQ+4ZBFbVPMNLNhkpaCKCr/aRkG7oR+4xCYuS7P2P8mrEeFskYrfYzkQlG
66WW34kinYYH5NS83z4KJ+xdg5TsH8jpEPJHywZfJLSB5t+KCAi1CYm9HYNBjB/s
NwSLbeXF6trRDtW8Hwja
=reLj
-----END PGP SIGNATURE-----

--=-hT6WUK0bwfZaL2w8UGUo--

