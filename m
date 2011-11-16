Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1KPSiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:38:54 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52949 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1KPSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:38:52 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/4] mmc: Logging neatening
Date: Wed, 16 Nov 2011 13:38:46 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: NamJae Jeon <linkinjeon@gmail.com>, Joe Perches <joe@perches.com>,
        Cliff Cai <cliff.cai@analog.com>, linux-omap@vger.kernel.org,
        Alex Dubov <oakad@yahoo.com>, Nicolas Pitre <nico@fluxnic.net>,
        linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Harald Welte <HaraldWelte@viatech.com>,
        Bruce Chang <brucechang@via.com.tw>,
        Sascha Sommer <saschasommer@freenet.de>,
        linux-arm-kernel@lists.infradead.org,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Pierre Ossman <pierre@ossman.eu>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <cover.1321398814.git.joe@perches.com> <d2c1a76fea1844ae7ac3e7e17183fb39df19178e.1321398814.git.joe@perches.com> <CAKYAXd8_mDF68PnEnpuZZQ+O8-QmrfRpP4jv+SpHDx1juTxFGQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8_mDF68PnEnpuZZQ+O8-QmrfRpP4jv+SpHDx1juTxFGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2319489.Vp8sye1eQN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111161338.53049.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2319489.Vp8sye1eQN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 15 November 2011 20:48:05 NamJae Jeon wrote:
> 2011/11/16 Joe Perches <joe@perches.com>:
> >        mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE); /* Enable mci
> > interrupt */
> >=20
> > -       dev_info(&pdev->dev, "DW MMC controller at irq %d, "
> > -                "%d bit host data width, "
> > -                "%u deep fifo\n",
> > +       dev_info(&pdev->dev,
> > +       "DW MMC controller at irq %d, %d bit host data width, %u deep
> > fifo\n", irq, width, fifo_size);
>=20
> I think that tab is needed this "DW MMC controller at irq ...." ?

looks to me like this was the only part you replied to.  could you please s=
nip=20
the unrelated context in the future ?  no reason to include ~1700 lines of=
=20
context when you only replying to like ~10 lines.
=2Dmike

--nextPart2319489.Vp8sye1eQN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOxAM8AAoJEEFjO5/oN/WB7usP/0XsO3sDmFr2DWVBW/lHyG50
lrCFD215bQKBCxKw3SW8cDOGHPGQWKgwgpELLajPOEs7xsYeZTbSh1f79t07uaGL
8Fzh+aKoM2dk4RXzJmBO1D2AavmMRZldMWGVeN8M/LIkPVmLeJ/0jgFmsMS/fa2c
Ki+6dM7YApc3L0Keug7ehZ1SDhZjxT47uj7jCYa1wA6eJPyxxd1wPJ1V27MokdEt
rJ/sMM61f2zKZ4T39idRsTiMToE9J57UnPocAdnw3IO2Nhq6gEmLfg6KE1DIz8w9
Jfr1Scivr8BQdINhSXCng51LQvyNyp/3vGqHufD2zksyaGekWG46I34sIVp+hZzl
/J1LcYxlebpl+6qblS4nzV/2ouIMmipF58grE+s71lsy9ptdQnSLZZEjSa+IXz22
MfkXajA3XhNf0NdGw2TB0rq+gS/hgrSmwjofEt+TH0erm+CQxc/N5VqHA7okHJR5
eLRokLZ8BmMBTkBEoac+u7858JoxUxpUoNkAFbTfT4PpXexAz4yd91WI6II+tG6b
kW1Htbh+hm36unT7VluB1em3WGYcBhsACeHh620/Vp80L20E1Z9NK1OaiLF6uyfd
8BIhqpY7RoXXto3Ce4tN3x0xhBD9XTlOh82geVHZ7JIJ60armEvtW+sJMF6uuPSF
wNVbieuwRBXj1ji2jTsn
=XUXI
-----END PGP SIGNATURE-----

--nextPart2319489.Vp8sye1eQN--
