Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2F3UBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 16:01:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2F3UBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 16:01:37 -0400
Date: Sat, 30 Jun 2012 21:58:47 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?utf-8?B?IkVyaWMgQsOpbmFyZCI=?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the pwm tree with the s5p tree
Message-ID: <20120630195847.GA24500@avionic-0098.mockup.avionic-design.de>
References: <20120629164946.97497f3eb94a5d4fbcc6b448@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20120629164946.97497f3eb94a5d4fbcc6b448@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Ernpc+SO90a2Qkcge4jS0KwxsuozHxD7cNQetLTASsS
 B9GKsvFb/YfF9ShjXCQVusg5axU0JvMD2S2qPo5dThF6yUAfKb
 w47edtdg9rqNqI87hvx58DszvHO/1rvo49PhwLZDpyFXr8eA+x
 yct8MNV6O8u5BeTbJ4DA9zevWedYtjRmBHrdu7R2kDUswUX+YM
 bMuEueov7TTINdCupcJ9Oflpwo7l8bsNe7AJ9J4d0rBuI/ugiI
 zhrlrUueFk4V3XNhGoOFXZaoWSa/d9RVhpULZS5l0cZ3aKp2N7
 jKErLSwmf3c4SD+0WG3Ayzq5aUn640KYYxHtvS1kKTkkEo+fHi
 tkVziSFR/Wej2aQYgvCuzPqZTzHEOCEu7Cmt2spU9EQbObXHJX
 IQOM0Xpqu+zPRkyRYXvdUTdQ2R5bA28yU688m73QUuaNGFV5g7
 nnCf0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 04:49:46PM +1000, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> Today's linux-next merge of the pwm tree got a conflict in
> arch/arm/plat-samsung/Makefile between commit 65ab16fd385f ("ARM: EXYNOS:
> Remove leftovers of the Samsung specific power domain control") from the
> s5p tree and commit 2663e766c56a ("ARM Samsung: Move s3c pwm driver to
> pwm framework") from the pwm tree.
>=20
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

I wonder, when these changes are merged by Linus during the merge
window, does he have to resolve these conflicts again or does he get the
resolutions from you? Or should I rather base the PWM tree on top of the
corresponding EXYNOS changes to sidestep the issue?

Thierry

> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/plat-samsung/Makefile
> index 4bb58c2,9685472..0000000
> --- a/arch/arm/plat-samsung/Makefile
> +++ b/arch/arm/plat-samsung/Makefile
> @@@ -59,7 -59,7 +59,3 @@@ obj-$(CONFIG_SAMSUNG_WAKEMASK)	+=3D wakeu
>  =20
>   obj-$(CONFIG_S5P_PM)		+=3D s5p-pm.o s5p-irq-pm.o
>   obj-$(CONFIG_S5P_SLEEP)		+=3D s5p-sleep.o
> --
> - # PWM support
> -=20
> - obj-$(CONFIG_HAVE_PWM)		+=3D pwm.o
>  -# PD support
>  -
>  -obj-$(CONFIG_SAMSUNG_PD)	+=3D pd.o



--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP71p3AAoJEN0jrNd/PrOh5b0QAKDa3st+sacQUy4s0/b+ekR3
DuANuJYFTERQTF/4BD9mwtu3dabGv+x6rmArFsGZKbYPG/1W8g4r93PwtBebB4Rs
qqWM3uP23omshki74bzriHi1j1EvH9redbJh7GKjTM7PlSvcLflhrPt/MErEWcZM
3TSyev2meMIXLQm2R/+57prH/dYhRsGqqDyM2A1nYynbH59TYPBgZZsxFx5JvdhH
p/BIllwzRFqDh77MHaS8ZDi1DPfp0aanaTP9D7MIlIgK6MN9P+m3H6YqpXe+dwr5
8wWq0Kiff/4KKGs0OBUArM/glUIIJjImDZfAGGNCLTGbyi0lADJEDgbaMBFy/cPc
8sH/GBac8iodMXbBv+OVtewaI6Ejd4SNQ4yXyBg1sq13XcUZIreFtGno3Pcend8L
lLodWZsBNRkY9beDcspJ+dqzY2AfZZxihd7WaB1yd0HqdeL9z8Q3WElTqP2DE6Bp
roNg8gPpLLZ2uBS3CyR49mz7fDVOtkbvg6g7m52O2tpidqQeRNorwxoRmv1eADpe
oEPFf+FBniqwhz4c1beqPwdi0zG1y3gneBDUFzmAmqCtHj/GOLt2Exyc7MG8EAOj
S4vcji0ac4IDPO24zLl0x01isukfPlq2H00PSxELaW80r/8mfFMSVrQiAEKduSZ2
Nzql5dpwMuTfJRn2Wdav
=hdrc
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
