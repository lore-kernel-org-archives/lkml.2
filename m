Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2CNOLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:11:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53295 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932483Ab2CNOLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:11:13 -0400
Date: Wed, 14 Mar 2012 14:11:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Make s5m8767_get_voltage_register always
 return correct register
Message-ID: <20120314141111.GP3133@opensource.wolfsonmicro.com>
References: <1331348383.3654.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D3I0HgOdJ5+6n+7I"
Content-Disposition: inline
In-Reply-To: <1331348383.3654.1.camel@phoenix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D3I0HgOdJ5+6n+7I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 10, 2012 at 10:59:43AM +0800, Axel Lin wrote:
> Check s5m8767->buck[2|3|4]_gpiodvs status in s5m8767_get_voltage_register
> and return correct register accordingly.

Applied, thanks.

--D3I0HgOdJ5+6n+7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYKbrAAoJEBus8iNuMP3dThsP/28/tcficQRp4P8HHm7bl/ep
BezKr/S84HbkSvGc3GPO9NcT1j/FnRqAhxLnpiF8qquLosMlRmqHk9PLtsSILTlK
9Du66iHhUYG1YidCEMjCEO80bk8Z62aDowLYqGzHXgaCaPtoVO89JbmnxcLjjnqB
krLu+vW8CW/h7iujeHTKAP9DWZkCLPBdrnFjjAxL5IwW4MZPZmy8ZeqiCdoQfz0j
+f1yD1VDTdkc/Sg5ilgvqlWvqnBF4GdI7AhhlSiMsR14WLDc7r6oJLeC/hvvRyaG
lOsPJpz0TIKi1RIGIi4jWsgH14QP373SaB7Yh+PJGk2KxdneeC+kMTejxKFBGj/Z
j8KHsVfoZ2eAA/OEKRayAuyk2htfptlJml/qit2hOjZyE1E5+VmLWMH0sYzcBzXC
YEUXksrWOv0DlTT9SQ1/Yd6jvYldTi3E0fE7ZB0s2iotIWI9J97D7j6pPUz19bip
mmNBhQvHTkcJyy6DaKwuStgGSe6Jiib8LOexqetVzIXcnMuBxzgknm52SlWCcLJ9
YMCFGgoqZdEVvNYaTYyne2hEqTjyGq7hBZJVWj9LVL/eHvrODt1Xjz4yXuz4n+/w
2BRuG2L0cWI2w/xkc0Cqw47Qgujqnm5vIU7LjmsXNdU+PxXUqxVWr2k9oRcGSjc8
tyCg2La/JMhlQthtuWgj
=sihE
-----END PGP SIGNATURE-----

--D3I0HgOdJ5+6n+7I--
