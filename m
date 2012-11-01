Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644Ab2KAObe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:31:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761388Ab2KAObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:31:32 -0400
Date: Thu, 1 Nov 2012 14:31:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [patch v1 1/2] mfd: i2c issue fix for DA9052/53 and support for
 DA9053-BC
Message-ID: <20121101143130.GI4413@opensource.wolfsonmicro.com>
References: <1351750722.19193.16.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AptwxgnoZDC4KQWS"
Content-Disposition: inline
In-Reply-To: <1351750722.19193.16.camel@dhruva>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AptwxgnoZDC4KQWS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 01, 2012 at 11:48:42AM +0530, Ashish Jangam wrote:

> This patch fixes this issue to by following any read or write with a dummy read
> to a safe register address. A safe register address is one where the contents
> will not affect the operation of the system.

> Apart from this the patch also adds support to the DA9053-BC PMIC chip

This is two separate changes and so should be two separate patches (one
is a bugfix and one isn't...).

--AptwxgnoZDC4KQWS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkoe7AAoJELSic+t+oim9L0oP/Rp+NfA4t/2u+03dBoxmDC7e
UGcSqSOa1RojBAF+rnTjdR5dG3EcopmaLg2syJWJbIc92cH2ABHJb/t7tArosXJi
Xxf/opInxdGzlZSW0U1QAqg+momKCwGeGykjqzCExCRWN+uDRY0SPimFo4dOrzeK
tO2kBe1HhSOZN/fw+I7OnJdxmJtLX+KqQ+Sk2S5Ih1snYv0arJwVNFHRTaZWkfOl
zzC0+zrxgUESyjAKfABWsAN5ZD5ctugepLaBfhptzV+blchmUYt+MylcDNyODuT1
el8toHVjA40E2aWbQDQTQOaWlVzY/cwVjnhQ1TfUcSVWNrJCSQ/gUeGw8V4KYSXd
SSiMvszMawfIy78ZNrO1NRNsh0tlnl6ooJXXOmdOat2cnmzBZbfTx5VVqM7TVecM
Ip+PZ4P3Wjrkjo+svFvfnygvek4SW6SyQYbffO56yw0F80FhXcQ+I8ZYv4NkC1Df
BulJdbclWCB85AHAz0mbDozcAAie2slpi6GPwIcJPjGBUWZuXtYCPnKoBgS3S9l9
FHGx6F99AjyrslNYZ8zJarIu5xHFPxINcEDOBQV901bRwVV5YfRxonG2Cfs4JL7u
U//CVyxCqisw6RowvrUaUtv9i8HhmU/OVH8VSPIpUXNun+8bkIvQpxsTXlgGyZRw
/QvFDEDaotgfDvLf8s7K
=5kdC
-----END PGP SIGNATURE-----

--AptwxgnoZDC4KQWS--
