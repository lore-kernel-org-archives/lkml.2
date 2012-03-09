Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2CIMxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:53:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42775 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075Ab2CIMxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:53:16 -0500
Date: Fri, 9 Mar 2012 12:53:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Use array to store dcdc_range settings for
 tps65912
Message-ID: <20120309125310.GZ3273@opensource.wolfsonmicro.com>
References: <1331247941.3570.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9baxdNnpTjJ7oIU"
Content-Disposition: inline
In-Reply-To: <1331247941.3570.1.camel@phoenix>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R9baxdNnpTjJ7oIU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 07:05:41AM +0800, Axel Lin wrote:
> Then we can use the regulator id as array index to access the array.
> This change makes the code simpler.

Applied, thanks.

--R9baxdNnpTjJ7oIU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfzvAAoJEBus8iNuMP3dcuIP/0S9N7EOOjzvZTDqmZGqN7fZ
aPcO0mjK2LcmQC0D82JmnJbP9JNL8PzNPwaRIUANC95FBNxhxCuz1EQ8dBxoldmq
j9eY/aa1Hniy4PYE2vxo89GbYRcFRetpBVC4iD9YfJVhs7/HGaNAgpyxhc1V2+CJ
FdAYK7/v4tUbdBkESKAhqddetwHsZkw8aHyLEN+Wh8Z6sCNy484XKEqtbBoaEkNw
aFQIAmv4EHvCrjAfI0w4QdQsQWIWcJpEg/Wz1sLV41pCc30lN8HmMQsA8lkhO4tQ
TrdlmHT39ZQBLuCmgyI5I9hv9YLJ/GDeJU2AHvHmH+KY95k9ACERbeQv+wvEeXjt
UBrxUIqpUx63mRTGXoq+eb1BikTHg4ZdK9MFeeEfob0HI4EWaRMxWbmVkIChTnMu
p2SUFahgGr3XuBZfVj2QiX4uJFPW7uZ81jsb0VUrPj74BbPHPoiejqo4ojPKnUQY
WFBel+/r0A6V2+FQxpikoagya09CKeUSDKYGU8dmg4Wx/59qPayWx5PhzRdReBAo
3auHZCSO9M6XlzCfPlTZhJT2uWv2Tz5f8oZcR0KV38BGHajkzdFtnJ9HkC+YhH3B
0l/UXcbwcVlATrjMYknCHEnI+31uK4om3Y/Xz1kWlDndDf6Imi3oBmjIa5Vvy1qy
OW8Ux4Qm43xGwVlBEPYx
=5TM4
-----END PGP SIGNATURE-----

--R9baxdNnpTjJ7oIU--
