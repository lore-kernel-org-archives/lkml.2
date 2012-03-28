Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2C1Kxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:53:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51850 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758077Ab2C1Kxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:53:36 -0400
Date: Wed, 28 Mar 2012 11:53:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] Regulator: anatop-regulator: patching to device-tree
 property "reg".
Message-ID: <20120328105310.GG3232@opensource.wolfsonmicro.com>
References: <1332834841-13925-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2NLGdgz3UMHa/lqP"
Content-Disposition: inline
In-Reply-To: <1332834841-13925-1-git-send-email-paul.liu@linaro.org>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2012 at 03:54:01PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> Change "reg" to "anatop-reg-offset" due to there is a warning of handling=
 no
> size field in reg.
>=20
> This patch also adds the missing device-tree binding documentation.

Applied, thanks, but please do split patches.

--2NLGdgz3UMHa/lqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcu2PAAoJEBus8iNuMP3dPMEP/39nir3X0wuJul5X60f/+PLu
5NKTmWK3gTjDpG3GS/yNp4zoKLywYhh+Ww705C9WGmxv6zRt/asQghcC2PqNh+KT
xusoYWc3qPwFnLdf0MTZX5DxbiZG0snGKtZgmfLrKP7LNuMs7RXmjCu45W41tLQ9
Y1hNDVyQuDe0N1ZRPx2MRtyPprwvbqkyxoESyGPS9RYzCPqWlZTmv4jv8dXeCSzJ
RJHa4KzjYTToFFPNwHrKcIOqd4LYq8HnGmNahr1NVlIKmAybqjZM8+z2Q4ISvbwR
cDlv1VY8qdjDnQ0LF1awZ2HfRU9lT2cJYsv7Qmz/Uw+yVTnXJFwnQRJ+ZzlGiF2+
fqKWcB8smw2TI3NmwB5NdVqtsnM/OuhDveKH1jze0hRLLYhPFAAMOov+NG1mdL6q
LMLI9KCAG5PryAkgdcPbW5T7gX88/8euVUddLh450luv50ZAEuZfdC+JbJOqCMDx
3EX6Vk1GYM/gS4dHlGQnPsQHtpXTNjPdoaC7MhkGikfyxP6c7lmuaQbNwF8OncDB
CZJH8sQX12srwXV1Hcc0Tdibf+J6dbpYWFErZVEcjIoM3WDl2EHSmbG8Wdyj1cyO
3ATRRruH6z8nNKU8U/ag22///roKbdA75J/9+1RvDUz/umi+U7EHDu6cRsOp+f5G
YsINYyoJqV9LQQumZpGh
=11Dd
-----END PGP SIGNATURE-----

--2NLGdgz3UMHa/lqP--
