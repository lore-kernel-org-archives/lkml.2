Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2L0R3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:29:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54108 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2L0R3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:29:09 -0500
Date: Thu, 27 Dec 2012 17:29:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [PATCH] regulator: 88pm8607: Update update_bit for
 BUCK2 in pm8607_set_voltage_sel
Message-ID: <20121227172906.GH5005@opensource.wolfsonmicro.com>
References: <1356311618.4697.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZOudaV4lSIjFTlHv"
Content-Disposition: inline
In-Reply-To: <1356311618.4697.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZOudaV4lSIjFTlHv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 24, 2012 at 09:13:38AM +0800, Axel Lin wrote:
> BUCK2 has the update_bit setting, but current code does not set update_bit
> in pm8607_set_voltage_sel.

Applied both, thanks.

--ZOudaV4lSIjFTlHv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3IVaAAoJELSic+t+oim9i4UP/jkdIGpCHPf/2bQqzoUTPEeS
DNZ30XkT5b/s2OlkjnAeJyT/ViHS2injAdvPYPaNsY+gK3wdo4oipFa30jXFNlSB
LNsaRZ19QC3Ls0mLBCyy3vuR1DbNccQiG+Dr6446HUkYKqDv0U3AL2NM+YpwMvj6
kKFdYY2JnNG88WIi7oqmx63BwA1mdnILeBElenygMFj4463fmOQinFI8n98k+2ht
rsqSYkCM9bkWSRb1WhIkHyKpBF/GSJRO/sC2DedRsSsdo7hmyyWc9znh9Hen8d/I
5bheqzlkZq/0xsdUkkr7UxWl3ruHEurBPhhZ6jdJfUawLeBInlmq54Z0Q9mLtSYv
CfAseZEOeaXUHaPB6cIU85Ly5QeDOiII+k8AKAXMrw+k7rPJVagttztnDJgd+2rZ
6MmEgtwdtcSS8ZqdWE1a1bnxCR+e0TF2Ycmz0S0UDhepHza4YqJh/S05pFFBHTLq
/KWSaEomz7PgIrI/nmMD9egjigJF1gj0qd1H11+ZFNZDoxbNRwKI1/jAnUWdE3jY
BBRspUsbXEn0Kpil77I0X5bs/jMioGyuLa0oKX2O5SgaYGX7jyyCNH/V5mieC6rz
+1emtcgCJdr17M90ENie94lVEgq0HK7zYrP8d81fmUcRtyDiaep2u6l1gUfDUmXv
3uUNhB/+dX9ZD7nAq345
=BiAi
-----END PGP SIGNATURE-----

--ZOudaV4lSIjFTlHv--
