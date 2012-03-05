Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2CEDE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:04:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48394 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab2CEDE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:04:26 -0500
Date: Mon, 5 Mar 2012 14:04:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: manual merge of the sound-asoc tree with the l2-mtd
 tree
Message-Id: <20120305140417.e55b7f1f0f0a9280dcb73040@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Mar_2012_14_04_17_+1100_iWn6CpgS7GcIz8Ul"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Mar_2012_14_04_17_+1100_iWn6CpgS7GcIz8Ul
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/mxs/mxs-pcm.h between commit 7079e020563c ("mxs-dma : move the
mxs dma.h to a more common place") from the l2-mtd tree and commit
016ab467aa53 ("ASoC: mxs-pcm: Use dmaengine PCM helper functions") from
the sound-asoc tree.

The latter seems to remove the need for the include updated by the
former, so I removed it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_Mar_2012_14_04_17_+1100_iWn6CpgS7GcIz8Ul
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVC0xAAoJEECxmPOUX5FE9qwP/RNK/GzB5WnqyAb9XcrXIIXJ
6EEAEpFLT8KIhoUtIE87xUfPSR0VawKAzx/qx2SHHz1jAodGzn2GA2V7iJYnP929
G7W4AUDFd3htqM6nBIwspEbe93a43T5SYZf/vSCOjEwG+adjtaWyo7CeiyQES1LB
KuXgG7fRTihc9axyR4qAIzyNoL3eNxlyVNJSCxi3yNcgD1AZnA6IDTlUPAI7DHuT
0ggLv77jQwQeYsb4Ize0t7F0F+jD9KMCSeB1XW6uG2w3Q55DuRR+ondY9uSW4+wd
8F1wXjhfvsDlO/QQawCKqIuKCN8ENXXP7nNZ0ITAAag8YFfccLp/6k3llI9y4HJK
0/WSOxMEGJChfTBz7S+cB12KenQYikHaqUx+4fVNoKKi3t9K8hDonubzX0IL0mU+
B3FupaJmLDxWpjId+2FuGkO/ApaP7iph9Ft5ZxOqA2j/7djFIOgYazqpNf4TeAkz
OZUospm8iKIR+vvvRqlQpC16BDczqRE2znWR4V9z2UDMJ9AuXUzPufuknP2rcXrh
JySExIdRMOTX9uhLb+cegLg2oYNdRXMrJ4z9vD/7xB70ZWawd1SLpB++ddBDhXJ4
gY+nftLiTc4RbS9JQrXJgwkCvpgCqzcRSGQefbxZOfFVSChHM5NqFy//nzJzkxcV
WS95E/oxB0lX4xyL3m48
=98n8
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Mar_2012_14_04_17_+1100_iWn6CpgS7GcIz8Ul--
