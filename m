Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2KMDho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:37:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34927 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2KMDhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:37:43 -0500
Date: Tue, 13 Nov 2012 14:37:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Yongjun <weiyj.lk@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20121113143732.624361eaf8ed2f4d0d64dd7d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_14_37_32_+1100_SjYREEFple2e1T0f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_14_37_32_+1100_SjYREEFple2e1T0f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/musb/ux500.c between commit 9a65d162e449 ("usb: musb: ux500:
fix 'musbid' undeclared error in ux500_remove()") from the usb.current
tree and commit 2f7711642559 ("usb: musb: remove hand-crafted id
handling") from the usb tree.

The latter supercedes the former so I used that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Nov_2012_14_37_32_+1100_SjYREEFple2e1T0f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQocB8AAoJEECxmPOUX5FEonkP/3X64lhOSDNEnRa9f0DNm4Ow
g78oC4u+Zf0OsG9AG+robFHc+uKwBAz8e81i0fdxoQgVq14HE5lVrOt8oOLG6t1z
qWZmau/nyy1VFZ69sWxvGB69BgkphOznD9OKnhORmJNUxFq13MQvnFES2VxVgs3o
3MtL9UnGiIFvrUHIGSLrCIjjDwVrHdnAqWQlIUMxQqsGXbgvoKCO4EbnEhtaOrLl
YaZsSMtchTpr/ei9cur9HgDev08tlEfMhgcUh6qvzv3yKcNs7jdQ7QPjnBSeR04v
IedsI8+vT7X7+k1ceEqzmCngN0/Vpx+iGJixvpFQBEMSxwtro3faRK7lPh5ckAis
eRpAM3IoClvFGUS258tjH6qxiOvYHwmLaMqEP1afXO2nljpqw1/8b2rafdHbpnp3
mGxBJ7EB4Hrrd3Cq86Xl0cp++Leclbr6wBdewkkp4GDcal6sdz3/5ybPesOEERAN
Uk3d1S3zQrRZLeU9Nl6FzTX2Hyxdak2xHZEBHJWRIUyYS2XVPFojJCwdOH5i/4GP
rg68SuF0adhkLomRfn764JogFG0XHgnEsYhNHoRlLIYxKXTrjgQkj8Z5gEFGWYto
U+Cg9mN9FgxVg5AwC3Y+Q0B1MTX2ZnCOwYZJnXJP666W+urX8Y8Q0XRt7RSoBFde
pJ7AfHeIpwsRTvVFhVAo
=nNiR
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_14_37_32_+1100_SjYREEFple2e1T0f--
