Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2HTHNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:13:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:13:30 -0400
Date: Mon, 20 Aug 2012 09:13:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20120820071306.GA2409@avionic-0098.mockup.avionic-design.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
 <20120818094846.GA24812@pengutronix.de>
 <20120818111745.GA15702@avionic-0098.mockup.avionic-design.de>
 <20120818121628.GB12839@pengutronix.de>
 <20120818123527.GA28701@avionic-0098.adnet.avionic-design.de>
 <20120818190152.GE19802@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20120818190152.GE19802@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:a5fyKbGbuxrUUtr2u5Nm6yGMMPGLmmKaEGi9Vdk8nb5
 TDtzPv/KQeJYOY3+9bA8Adt4jIGRInWclKEuuB6Z9mLDaQ7Mjf
 AmSMgGFWoYWTlpPcAK0JqAzkoLZfEh70wtW4tmvdEqzi7OmjBD
 /csZjiyP+hk5rWa/RGZNai2gc+gBe79WejoJZ0K7IZ8JZz9gtt
 WkmPOHbUCXotpjGgw+lTcvEKXao9k8btbCG5G03d3yMEeM271f
 Sr8HEKWpBe4aZyCZ48YyPipxGBDdbSdvTe0er8FUf96YRjh1kv
 ydIJ2khByBLlee0g6KK33iH4O3tc+lDTb6uc3cCD0FdoKVhl28
 Fjhxnj3R0AGwxC2SlrBJxCR8PbZ5QL10xKAt4Di4YCk9LP4g8R
 2nztgzIzexxg+xSccGQsc0P6U8fVhlw+anjGBU/PCT7lO/rURc
 0jthE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 09:01:52PM +0200, Wolfram Sang wrote:
>=20
> > > I thought to recall that busses which can be probed at runtime should
> > > not have nodes but should be probed. Maybe that was wrong. Can you po=
int
> > > me to a dts-file with an example?
> >=20
> > That approach doesn't work for I2C controllers, though because you
> > couldn't attach an slaves to them. The same goes for SPI controllers or
> > any other dumb busses that can't be probed.
>=20
> I understand the problem. I was wondering how it has been solved. Thanks
> for the pointer, I got the idea now.
>=20
> > arch/x86/platform/ce4100/falconfalls.dts is an example for an X86
> > platform where PCI devices have associated device tree nodes.
>=20
> Do you intend to send a dts file mainline which needs the patch you sent?

Yes. I have an x86 platform which has an lm63 temperature sensor
connected to the i801. There are a couple of loose ends that I need to
take care of before I can send the DTS. I can send it for reference, but
it won't be of much use because other things are still missing from the
kernel and I don't know in what timeframe they can be applied.

Thierry

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMeOCAAoJEN0jrNd/PrOhdIoQAJpLYLtD66Q2pYMOsdSJOcTv
16qyRev7xDoXX30bhzlbBqOv3BsnPrDcMEMr5jcgM6GYNb91N7HzH//QV1sNBsoY
UZmbrvrYutW77u+avvn8tLIC6Cg8wIfl50tqLGzksE08DQX8OTVw73co/EZoo924
2sF7NmIJlLXs007zaHAk3ftS4Xtj6aVnARy8I88TLIJgXLMsdtbr7MdG9aKPCuHd
hiyDsgFaHfaXEBsUFvKtOpPDulNt36ecL2bQCmqTur/OaZm795/6sJh5ZqzQfHbd
x0gt+ZhrXZ4jRa4IfKg/laCHhy76VHI0J9R5KvPaZEf/9MXSVu93du4lwOguxV/K
WsWpUAI8ltbReC/QEPNseWhqNQNJlicRS28eyiSCazuQ8M1YRN7lp4L4UrYI3Y1t
PSceVladXZ885k1Fm1rhSgGMYQ3PAo+6MguxtBRNUFZX04ss4QnNCTiluoiL3v6D
rXcLIlosbYmY/vEGsk7P1D53bulTggiUkh+5prytI8tWz6ybEWHN3BmqiM1ZBWdp
T2nm4V9jK9zIlrfDrkKJi0PPq2xkoVop3D5vnwVXMUNzuVPhFlhL6lSw/TktX+nC
ySW6NuKkmwD5YikM87yv66ACdZg1Ys4zb7pWXZinKUpH0xA/o6eFLTfFnWbfxpH6
tc9mxAcDbdDEY9Dt/stT
=UuJ3
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
