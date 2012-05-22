Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2EVJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:25:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40771 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034Ab2EVJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:25:55 -0400
Date: Tue, 22 May 2012 10:25:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: Fabio Estevam <festevam@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120522092552.GB21999@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <201205221053.21792.marc@cpdesign.com.au>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 22, 2012 at 10:53:21AM +1000, Marc Reilly wrote:

> It was a new format which introduced a padding bit. I wonder if Mark Brow=
n can=20
> comment on whether any other devices are using it successfully. (Sorry I =
can't=20
> offer more insights there).

It's only this chip that's doing so.  I'd suggest putting a scope on it
and having a look at the formatted data.

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPu1uZAAoJEBus8iNuMP3dhFgP/j1YEklxhF1PLE4uEmyJ/vUt
yJI4Uh8x7TsmriaPw/JlQtj4IA+04LZdDB1Pbn74X2/gsS0I3PW63GIASYfj/x8G
q8TaK3+CLztIrR+hsGXEhX0YDRFbaCyCCxnACeZEzgamUOYEd2lXOC0OiwlvmXQF
+uWSuVvtl8yOr4uSyIve5adYxVVqYo/K/M2dqGt9HKTCSDpPsvtlfuXT82UMScYR
rUtKVnTflfm/fIirKCyIMWsdQIT/7Y+DNeMT6GqvBidIUj09Rxwz3IYxzV9kuhB/
73dIwxxsFOq91QvdYLsq8lurcp2+pqlA2GjFOweIrj+EEYAMlVvCos0s+qapfvQw
/Yvif5wRXwrB6vf8VUWHzp/U2rpm9r2KwwNzRb1Rkc2GGGMYsrd+1oNmbDcTzVW3
OxpmfINfwcCE1Di/XPw42SYB2l3POSnYicSAn9PS9HR4/s9yAmmPsqcniR4WwBBw
7Mapv8CS7f600Zso5oyJI7yDyyfPmG9spPXdN9KabBtSKMJytRxjZiZ6EEFuercc
oGWPtOVJHehYJOkU8t8toRQNgU9CcVc1GfGw7wjOfVsOyIJzyWDNzwDuMjecUVlF
keLhlefAHNQsY227krKh3wAKucvAiB103gdJ1RH0u7u/6G0fMtS9b+HTA7cjR9X0
UIs/KdKfv2LxAwmMl2k9
=yo/O
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
