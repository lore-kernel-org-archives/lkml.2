Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1KUAIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 19:08:53 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56462 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1KUAIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 19:08:52 -0500
Date: Mon, 21 Nov 2011 11:08:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the slave-dma tree with the s5p tree
Message-Id: <20111121110837.05684cae0be90d4e7f0df47e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Nov_2011_11_08_37_+1100_VwYRUgdVUXtzLaO2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Nov_2011_11_08_37_+1100_VwYRUgdVUXtzLaO2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/pl330.c between commit fc0b5cccc8dd ("DMA: PL330: Infer
transfer direction from transfer request instead of platform data") from
the s5p tree and commit db8196df4bb6 ("dmaengine: move drivers to
dma_transfer_direction") from the slave-dma tree.

The former removed the code modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Nov_2011_11_08_37_+1100_VwYRUgdVUXtzLaO2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyZaFAAoJEECxmPOUX5FEDQMP/01jn4FDiN0J65XpMIXmlRZT
Tc+73JeEkeZp9lwxUdPvqBg6T9o+g9kv4lBNLGpXNDehcmqidN86NvRVNVsxg6hS
MU1nnQBY/kArQzq3JkaXhiWy66QBm/T+q1KM/6l/AqGab9DmOcrkfYLirZyxpgaW
DIT9XBDANpM7u1e5rCFk6TvllJBgStpPFVbHcL3IRKG+8kfVnGPhxA/oTzh7kNmt
rdAIG0G6ZdGRxry2Q0uJmaxsw+Spmq1KCM/0I7YhBB1adOpCIpZiT4OAzRfgNoUH
y11kNU/NTByA0DslO71OVOj58QRCjl8olLrk9gLuVtWWIhMZTl/9VM0r8teiEaVW
DG6RTPbJ6IX3uPdL554HCuona6Z9P57aSkAPcs6y/wPfrFAVO3fcHXRf0MBS4T4N
TMuyPxnw8ht2DlXmicx6YAfcOYyySspmViHARsCxjmmJ8IlRrTCmVWW2W558WLm+
aKJlVrOMqdTayBGbI+g1VGhy4Vp1Z5U/n1Q3Xcnq3qDWrMwyhW8BU40eEGAMfKDB
3N/Q0qW6lUgKn3OL5ztCUoXTJDRtWdv5tLd2ZzLzT5LOJ+ovjntB+BCugKjstIFO
z/dJAg/NlIHtj8CHKxdpZTjlaAoZqwTUtLNwM5cgFx8KDVH4az645RpI2/yLy4ZP
L/RaBTT7YgmSSymTGyvr
=Zu1w
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Nov_2011_11_08_37_+1100_VwYRUgdVUXtzLaO2--
