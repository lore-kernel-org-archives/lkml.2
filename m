Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1AQGAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:00:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44099 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1AQGAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:00:11 -0500
Date: Mon, 17 Jan 2011 16:59:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        nios2-dev@sopc.et.ntust.edu.tw, Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] spi: New driver for Altera SPI
Message-Id: <20110117165958.f89e8220.sfr@canb.auug.org.au>
In-Reply-To: <1295243200-28230-1-git-send-email-thomas@wytron.com.tw>
References: <1254981838-20584-1-git-send-email-thomas@wytron.com.tw>
	<1295243200-28230-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_Jan_2011_16_59_58_+1100_o1M42irch8Wbv.GQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jan_2011_16_59_58_+1100_o1M42irch8Wbv.GQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Mon, 17 Jan 2011 13:46:40 +0800 Thomas Chou <thomas@wytron.com.tw> wrote:
>
> This patch adds a new SPI driver to support the Altera SOPC Builder
> SPI component. It uses the bitbanging library.

Just a general query.

> diff --git a/include/linux/spi/spi_altera.h b/include/linux/spi/spi_alter=
a.h
> new file mode 100644
> index 0000000..b3d7f69
> --- /dev/null
> +++ b/include/linux/spi/spi_altera.h
> @@ -0,0 +1,12 @@
> +#ifndef _LINUX_SPI_SPI_ALTERA_H
> +#define _LINUX_SPI_SPI_ALTERA_H
> +
> +/*
> + * struct altera_spi_platform_data - platform data of the Altera SPI
> + * @interrupt:	use intrrupt driven data transfer.
> + */
> +struct altera_spi_platform_data {
> +	int interrupt;
> +};

Is there some reason that this struct definition cannot just be placed
in spi_altera.c and so save a whole extra file (and its inclusion)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_Jan_2011_16_59_58_+1100_o1M42irch8Wbv.GQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNM9reAAoJEDMEi1NhKgbsZqAH/jh2V0e38zKKPugvDETezbC9
1/KuXsK+Q3nq7+5r7jDBkQeyx1jbPwGoFBVNRAh34+CekvrpMc69XdFqGoIMRMBw
HVKWBMhCAL73IS0PK21ewOGIlI4pyNf0XJS5iS3WmllZxSIOn2UI0soGhW1ic/Ya
eVOwFawjCJ1OTnAFMrNfpYUD6VqG32r53mSMjWsalHvX/7yJYZFJKPY2NDq4c2b6
wMatp9/tgDf0ajbauJr6BvJ4ti8wTf5rWf0enxheG1VMYp/Qgoz81g3gQ9iyK5S6
pUuPs0wxkJI+z6p5YGSgZKRRrPubyvYBY2tuWph/az0qZ8NxDEOgIcHGSm6xXKk=
=gZYc
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jan_2011_16_59_58_+1100_o1M42irch8Wbv.GQ--
