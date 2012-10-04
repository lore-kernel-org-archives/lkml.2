Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2JDCV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:21:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55121 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2JDCVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:21:25 -0400
Date: Thu, 4 Oct 2012 12:21:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the drm tree
Message-Id: <20121004122115.2d59a5301715308bb9d53ffe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_12_21_15_+1000_0wdQbs9EEbzx+Wxt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_12_21_15_+1000_0wdQbs9EEbzx+Wxt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/gpu/drm/gma500/backlight.c:29:13: warning: 'do_gma_backlight_set' d=
efined but not used [-Wunused-function]
drivers/gpu/drm/nouveau/core/subdev/gpio/base.c: In function 'nouveau_gpio_=
isr_del':
drivers/gpu/drm/nouveau/core/subdev/gpio/base.c:219:4: warning: 'flush_work=
_sync' is deprecated (declared at include/linux/workqueue.h:448) [-Wdepreca=
ted-declarations]
drivers/gpu/drm/nouveau/nouveau_drm.c: In function 'nouveau_drm_open':
drivers/gpu/drm/nouveau/nouveau_drm.c:503:2: warning: format '%d' expects a=
rgument of type 'int', but argument 4 has type 'struct pid *' [-Wformat]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Oct_2012_12_21_15_+1000_0wdQbs9EEbzx+Wxt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbPKbAAoJEECxmPOUX5FEKAAP/3FEz5VY6BsL4Z969pTX1E8y
S45PJ+f8I7o8kG0U5tCzDtrNB4/YdpKhTCaBJCfe+YDJuPpj8ENbA9g9HVMLq5G/
0If1Lz+svnS7dKjWmht8HixTqUg2cewyBUTBlA2fr0m5u3GooLPk0v30jz+12M9S
x3cdjHGgKpGgtX5dOPg2sPoKLeqglcoSBOtA+Wk+VZSXKJccKuvOFA2HG4aaMeWY
m8GjP84+/vz6z3hWiTbZNk1zewuV+6EVEdCzlo8a6CnsBvkssVQXr8ZYmenrn0HA
ldpWxNjLDQu62B98ftrEz7x1xAEaieQzgkiV88KJM0pKCLc6LrmuudzAuhG24HRB
CMrxEmz8cXFdrgmTSRoLqbNi0iGHDN+gNoEJ8tQSExBpL70LEIO4Yon48xjICo3X
oZ8JJWxbxgdJq+ITMVAznGRpbt3lsrjUtjomBI+JCnNnshjFJr9p6weUrUwMSP2n
1b/ntiflR1l4+5XM25kKrrvmhZ4V6atp6+XzqcsgrOEYOkdWyRFWPBQc2EnsUuTO
NWpvkw3bEFBzuyYgvxTAfxZfH2zFVQUpCqK73IonnjgY9tsVAChrl5H5Zwn/g0CE
vBtISGIyhkQmZZZQnhMC4pQ3ukRxJxpIvFQPW533F3/H67T9iSnpAEvOBumIW6cl
wBcG3UACS5iBPW6785tH
=Y4Q7
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_12_21_15_+1000_0wdQbs9EEbzx+Wxt--
