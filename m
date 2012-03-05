Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2CEDAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:00:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38188 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2CEDAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:00:02 -0500
Date: Mon, 5 Mar 2012 13:59:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: manual merge of the sound-asoc tree with the slave-dma
 tree
Message-Id: <20120305135949.cd08aaf15f8bfa36d35dbc98@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Mar_2012_13_59_49_+1100_A_JMbom0XNiPPmhk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Mar_2012_13_59_49_+1100_A_JMbom0XNiPPmhk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/imx/imx-pcm-dma-mx2.c between commit c0fa6c8af7ab ("ASoC: i.MX:
Add missing dma_async_issue_pending") from the slave-dma tree and commit
c307e8e32e11 ("ASoC: imx-pcm-dma: Use dmaengine PCM helper functions")
from the sound-asoc tree.

The latter removed the code modified by the former, so hopefully the
former change is subsumed into the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_Mar_2012_13_59_49_+1100_A_JMbom0XNiPPmhk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVCwlAAoJEECxmPOUX5FENwEP/jIpazfgnGbuxw4wERni660g
Ir1KcXS0Ymy/m8PEGNQyRtNzOs6mWqgtD1aMSbciG69VfXAEeEbm1QacwrVmXmwb
R4HeZE3yTDX4AlTvQwSkNxZyk9yBCup8Sqxk/kRReSRxTOysP58e1dFm7Wi6Widk
kiFyEU8iPcck+aJlDuI6U+mbdb4xxKecygaojDFVD8HJB3+FhMF/+d9uvAklaOl3
kdcYguFmE2l2KRmXQOu1QVIG4ccF7sKdN+6CR6wWngA77TWCNoW1iP4O8KAY7d67
HKuR6AdNYaUOAgGgYPsAMxb5mhSQ/NAA87BDZuJ2CVMqzVoOw8FMA0pOIxRiWvNX
Ya5xQ8I3/M5RSfRBejqXdWF/Ul6RfYsD9Q5044fEVk2thUSVk9CMCMLscDiV+Cp4
hKUVuYXx9kR9oZJRsBx9zuC1RF+8QtKKNvKuMsF/5TrMpRQ4TjX+XJes48isg1kp
dzHxmczvVnNSPIVncFNYSgE/GztdmcbTYJKatmTneuLQuNK/ZNfeOVaqtfLQo4bw
C8pyKL5uzOY30PI4kC6mp6rm0DG4s88znyysUC8BDJJadmpHXZhf131Ws/c9uxHE
cYybS+6QCzQtvgTj4dh3RsEnKPNCpL/Z1+KSAHbYBz1Uv3mhBC/+21083WI2F4F1
q4E56pOQutk4MTVipvoI
=1pw7
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Mar_2012_13_59_49_+1100_A_JMbom0XNiPPmhk--
