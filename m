Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2FLBbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:31:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58620 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab2FLBbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:31:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [uclinux-dist-devel] blackfin: how is the I-pipe code supposed 
 =?utf-8?q?to=09be?= built?
Date: Mon, 11 Jun 2012 21:31:12 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0; KDE/4.6.5; x86_64; ; )
Cc: "Zhang, Sonic" <Sonic.Zhang@analog.com>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "philippe.gerum@xenomai.org" <philippe.gerum@xenomai.org>
References: <1339365045.30984.78.camel@x61.thuisdomein> <DB904C5425BA6F4E8424B3B51A1414D170235830B4@NWD2CMBX1.ad.analog.com> <1339443890.30984.96.camel@x61.thuisdomein>
In-Reply-To: <1339443890.30984.96.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1554950.NAdYPBsBiL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201206112131.14430.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1554950.NAdYPBsBiL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 11 June 2012 15:44:50 Paul Bolle wrote:
> On Sun, 2012-06-10 at 23:05 -0400, Zhang, Sonic wrote:
> > The IPIPE patch is part of the ADEOS real time kernel patch. The
> > common part of this patch hasn't been merged into mainline by the
> > maintainer Philippe Gerum, although the Blackfin architecture part
> > was. The relative Kbuild support and Kconfig symbols are defined in
> > the ADOES common patch.
>=20
> What's the point of having code in the mainline tree, for over three
> years, without any Kbuild or Kconfig support?

because the Blackfin team cares about keeping ADEOS active throughout the=20
rewrites/updates of core code.  it isn't hurting keeping the code in the=20
arch/blackfin/ tree, and we're ok with any overhead it implies for the team.
=2Dmike

--nextPart1554950.NAdYPBsBiL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJP1pviAAoJEEFjO5/oN/WBWWsP/2llpZnyQaz1KZ3Usyh8jDlg
ZIKQViLzAQmexvC6u1mr4RRnhD8yNeefNmZAmNIpctp7xTh5EbdlZmXoQ1PxIc5C
qusYxoF0mLs8UMLCRf+ubJaSUU6+p2yei6rsNeUmJVEKUtsMSVUAFINkk6bMlzho
Rg3BuaSIdzBGMmaFe1ndFcYhGloyyddFlVv8RKR9aud+uVzBFOCn4Z6PrcIv+hZ3
ICLWuElkK7t8d+ehRYSzOuXSkZFa5XYXfzOzKm+PkbLJLFW07xkMq3m/2Mja5A1e
gcBn40foLcCwF8DJTT7MlfSkTOdiNNZN+vHUXLUr6fWvDFMgtGioggw85vfkaY2v
+jXwxdmG2xYhMEtY/luYMq+nwmr75wS71W0WoRmLyYGwO4wlU+fPwHtRIlb+AZ6D
854sUi0GyYX4AMon0wAI0ZH7fCVTuG8KaeWK6m6cPO1tkcDXvW+AbLFpJ8OEN0YO
7qSAZPnRZRaikrju3XJlIz/Dj419+0XO5SW+uall9ZvJtlvkRjRhO5dzTpfQmm9o
cA6u8nen05p8xfVzbuSHoxGfUtM8oXBv/L9G5gxtTiAN+usO4xrPyE8i3zk6ACCW
WLFvoQNJvyvuGnPTyuUSd+9gC7iagFEnvg1Lcjg1xugBt3XKBihZKvx+2pPo8KRa
EZslJb6Q0+SBj6FV2GTI
=IC0z
-----END PGP SIGNATURE-----

--nextPart1554950.NAdYPBsBiL--
