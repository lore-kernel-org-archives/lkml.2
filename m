Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab2GBUtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:49:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2GBUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:49:23 -0400
Date: Mon, 2 Jul 2012 22:49:15 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 1/3] pwm: Convert pwm-imx to use devm_* APIs
Message-ID: <20120702204915.GB16327@avionic-0098.mockup.avionic-design.de>
References: <1341102443.3712.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <1341102443.3712.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:L3DEx/Z//JlJk9QGJsxKcwYqvWdzgJWIZCY1KN2hSX7
 puAP7ckSdJsxQYNzruc+3G2xSIOjFHenELjwTdFBGRsYGeQgMi
 58LeiDoeSjJugH5x9GRNN3o70gmcvU3zmS/ueT0sx97OVtSPjM
 ZUZQqg8fbUgwrPparzsBq593cBAJcuSGPRpMiI0L3X+hm78Bh7
 wx1rKjSy5x348IDGpp2zW8A9Yls0WKXJ+TUKCgGyzJWMe/eTT7
 +WUllRKxdjlm6pSGx8KTCybealbXWn/hIE/p4P1Q8vZHaByH6k
 H6EsIzzC6IjjUDdMK/DIPmsESfFuyZWmlNh3kk3TGmFlxGSaz2
 5H1B20UjP0omYvQ6XldZiocyPuSh7f9vMzjj85HuE9yod1felF
 025Sxh2XIHBZgg1J2RkPBNOuUMwKMAcDoI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2012 at 08:27:23AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-imx.c |   57 +++++++++----------------------------------------
>  1 file changed, 10 insertions(+), 47 deletions(-)

Applied, thanks.

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8glKAAoJEN0jrNd/PrOhMdgP/2x9nny0C0u3ADX1jjh4BXQ1
Tl5dz2e9pKtQ1YanX1Fh4/vli9nLWChiGD+BrFjPujanTfmW7jyrmhOeOaZVANgJ
a7b+iFw70X7g9KwWwnfCTnVmwLWpdLMd1cCFcMPLNnQciRPmxWklJLpX/++Twk/i
Fzv7mewHF9r/WvaLsmM3KpJyVr5IsKLCVRB/xy6XXaKnrh04PwBmRc33KjH6riTz
Il/Z/i3pl/g+ZTkx9hTXKpfQL4sDctQ4PrPlg4xanIKVEboeYUobJTiT2EXCzqFN
VR8Dn7XLkQzaSqFPODxgnVxRnTyz2VIS7LC9fJigsiH7Jfrxw5Y58z0flDQcgRhx
lUNpdIg8H/g08j/uixo3KaCdcdmscSzSgN2eN0SKCE2EpgwWYvASz5DFvV8Yx36m
Xot+rJiu5lbr8KxGXNT3WOi6w7w9jwsd/Bp/j93M5KJvOUk9pYHceAFpn9BskwXZ
lRiS6XUBWdE8XgBsMoV76D44g3bBPnZiTC8dRkdkzLpXeNZy77eDlSGrmr2E7Hvt
F/jO68DKVGOmumIlgOqN9C7kNsuSly2g3KYgJ818mob855cdENptlcNhEaLj9C6v
tteXWnIUbZlTGRcyhZKBdhyMrcGTrLJi/alKpiE17WUY9FTkBaDWwfWJ9Y0YKNRu
PJPnVM65g7MFjAbOy7eP
=Cn3X
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
