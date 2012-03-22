Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030617Ab2CVCeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:34:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39143 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2CVCeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:34:20 -0400
Date: Thu, 22 Mar 2012 13:34:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: manual merge of the slave-dma tree with the sound tree
Message-Id: <20120322133408.e4bc0b6030b0d8d244cde8bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_13_34_08_+1100_WN_Uf_dFC0=lguB9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_13_34_08_+1100_WN_Uf_dFC0=lguB9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
sound/soc/ep93xx/ep93xx-pcm.c between commit d7a42e1033b2 ("ASoC:
ep93xx-pcm: Use dmaengine PCM helper functions") from the sound tree and
commit 16052827d98f ("dmaengine/dma_slave: introduce inline wrappers")
from the slave-dma tree.

The former commit seems to have removed the need for the part of the
latter that affects this file.  I just used the version from the sound
tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Thu__22_Mar_2012_13_34_08_+1100_WN_Uf_dFC0=lguB9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPao+gAAoJEECxmPOUX5FEa1gP/Ayp1ImDhvRJAJcNnOpSW9a8
+n3RPJc6c9Arp1W+ASh7IN66zTs2kN9PmzLQ9Bt7U/cXkakWE7/Ne3E1CTyNqZtC
LN7WBJ8b55LCGXMUqHxH3mteO0GBx4l/2hk9/gJbtC0DvfMCeXOanPVhV+FN1zaz
OPO1qi6DwTD/NODqnKahNziuyudWmCTkO9qIvcl+OvImF5OGZl2Cu/s7fX/2RTxj
fjldYKw588nP8xn7RxzLAY/2KBI7M9FTR2D7j1+0Nc6ZYwGOOaCdUs03oBBz3ZM6
jKsJZ52HDdqh/l8fBVPjgP4LF6GzglSvxv6Ikw0pM2WPLP5D5sMYUTSH4pnWOjDy
/MLxVKI0xsdU1rbKhG/oNXjf7uqVpJ3xRZphm1k5leSzBVen4hNuUAf/xFQQoNmn
/fbZirSpttln0NfBtlYkYzZRLDBeVklgQhmMGqLHItHucPEbYr0Eao3F33pibvAO
HyZ6if4DPhrQTuo/qsyeFQNTxiJyKVJOlKt8ow+IQq4cQepmxGImBPcmlnNPVy+1
OD3LAmihLLv6AmwgF2tJa7pJ76iCiugaDUh11K8w+yL1Gn5qlJtnLOlrSDObYITv
Ib34bo/8EsTrGTD7XbLsZxwvvWZgFftr8YrEC9OcVn7sRz08OYMUfoAaa4FqjRPQ
drTp3N6g9/dnOxfCNDxr
=C6+o
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_13_34_08_+1100_WN_Uf_dFC0=lguB9--
