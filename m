Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2CVClK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:41:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36771 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2CVClI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:41:08 -0400
Date: Thu, 22 Mar 2012 13:41:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: manual merge of the slave-dma tree with the sound
 tree
Message-Id: <20120322134101.e2342db0ae13a4ed79cfebfd@canb.auug.org.au>
In-Reply-To: <20120322133930.b75bb87714ef197d22d56cf3@canb.auug.org.au>
References: <20120322133930.b75bb87714ef197d22d56cf3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_13_41_01_+1100__6mkxIBmAJ=8BGeu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_13_41_01_+1100__6mkxIBmAJ=8BGeu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Mar 2012 13:39:30 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the slave-dma tree got a conflict in
> sound/soc/imx/imx-pcm-dma-mx2.c between commit c307e8e32e11 ("ASoC:
> imx-pcm-dma: Use dmaengine PCM helper functions") from the sound tree and
> commit 16052827d98f ("dmaengine/dma_slave: introduce inline wrappers")
> from the slave-dma tree.
>=20
> I just use dthe version from the sound tree.

The same with sound/soc/mxs/mxs-pcm.c .
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Mar_2012_13_41_01_+1100__6mkxIBmAJ=8BGeu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPapE9AAoJEECxmPOUX5FE86EQAIU5h2vU29+EcI4kabNSbJ9l
upyc0DvC5LO6UCtYiWUhu1Zl0IE5rjg4Y8LC0MHW7XtH1dHctC0EOfhpfogRYDlw
lE39XL1xDQcDQtOKFFcWyEIaJRDnCFN9Ew2QM/qSeyt4dfjW8fL/ACd4d1hG7A7G
RtYkijAL5HOz96s7lrgU9BMRtmnVT+hz7ydUXvpP8uNMi/sHww580CLH5/ufdbD2
THvho+faW4tKNQJtM02NKGJ9nRX3RmoGj757AiIgJ3SCiMYsSrIi4b8yn/LJABNG
ZZYvT3BycV6f5LOeFGBMZ8Cyxwv8yDtVa784QqjslfP8MMxSp8VyefOgycGfsOj0
z8MsDFcYQhmySlFRjKiWYGAJyM4Y1MEF2xEqN8ISvkFBB0RiIMW75H44nE57xfsf
qXbVxgjTA9DtW7qy6Hz5ImU9q44NrBc4BBLY/ZQtrpZd08GNI0W9RJtQCWdtWJPN
fbFR+H9w1xPt993GUsarklxOi/RJ/FOb8po/H14jODjQeRJc5EoIiLAiTbGsrE0j
UDL0IEoaPTt4g3Gtmi/+VDaf7Gzz9boxrzJUW/T7vRrjsUARq5Ue52sYhSjGEsrA
Yem3ih8WePVFanbs/EF8JXn62HSl5tx7B0GHvImebf9HTYPyk40kznj+NxqdlvEn
3+gV8FPXge7CCR2ZBoOF
=guC9
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_13_41_01_+1100__6mkxIBmAJ=8BGeu--
