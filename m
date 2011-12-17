Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1LQEec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:34:32 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33493 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1LQEeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:34:25 -0500
Date: Sat, 17 Dec 2011 15:34:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20111217153415.8e912e96dae9cca7a9128e4a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Dec_2011_15_34_15_+1100_wCYLIZQnVF9J8P1f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Dec_2011_15_34_15_+1100_wCYLIZQnVF9J8P1f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 allmodconfig)
failed like this:

sound/soc/mid-x86/sst_platform.c: In function 'sst_platform_open':
sound/soc/mid-x86/sst_platform.c:274: error: 'ret_val' undeclared (first us=
e in this function)

Caused by commit 03c33042dbcd ("ASoC: sst_platform: fix the dsp driver
interface").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Dec_2011_15_34_15_+1100_wCYLIZQnVF9J8P1f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7BvHAAoJEECxmPOUX5FEZUcP/RsVsov/3UGbj49HgRJzA2uQ
ytIwDg7EdLdLD1dDPOAQa/giEjx962JEWbhbwqMxSXxVXkSP+3EHAF3ijGy+ILkU
Z7CFUZAhf7tt/i0Mov+WtlPum721uDFas9QB0dKL5nJfw66VhiL8nOQESCD8MAXi
MyPlEXxJPoktiD0C9uiGhlYMbQCWslBvmWmleIQ0lwU4q6Cz8sc62Hg6qJtzEI20
hcmtUc2FGJj0T10183AHY2RG5pzhSUnoumurtFQdrGMpQgDTjhb6C4xRmTGe4xmK
d8I2phCXk0aVQAEm8TDaUnXbVwqHLpOqMrjACdTpOqSoq9kf3GwlZ3IrfyP2M+mj
viC/t32emKRQgBnGoS3zzUKU/abQTdiyq2i5RwisYtPVun6zqbk1xReFIYjNDX0D
Ocj74XGSsjM29uYTh/fbjLu6IA2Ky5jO8U+BCWZT01dDiyxKRe1GlDXco1zYYd+h
QSum3Hv4euy6TH2N8E/igfXEGWDKMIs2gX2+JiRoKElHPI/AEwg553P0rtfJLelT
DgG8ACUzAuwqRNVajnTZ8o5qRmuqP6dzOwwUuijPegvk0BomfAupUbsrWe2JiIs/
DN8F6U6IatmNFSHEengqUYQqSSvCa9ICD1jz0QqQYpkBjoyfKG782+DTslowO7Tn
WEJhW1OTNaRZ+qxNxArW
=IBLq
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Dec_2011_15_34_15_+1100_wCYLIZQnVF9J8P1f--
