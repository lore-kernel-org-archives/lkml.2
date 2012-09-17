Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2IQD3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:29:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39254 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2IQD3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:29:05 -0400
Date: Mon, 17 Sep 2012 13:28:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roland Dreier <roland@purestorage.com>
Subject: linux-next: manual merge of the target-updates tree with Linus'
 tree
Message-Id: <20120917132855.097d98caed7d0ec3642a6302@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_13_28_55_+1000_R+E=Th+e9.zbYQ5C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_13_28_55_+1000_R+E=Th+e9.zbYQ5C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/target/target_core_transport.c between commit 6138ed2ab879
("target: move transport_get_sense_data") from Linus' tree and commit
867c8e7dae31 ("target: Simplify fabric sense data length handling") from
the target-updates tree.

I just removed the latter version of transport_get_sense_data() (which
has been renamed to transport_get_sense_buffer() and changed in Linus'
tree) and can carry the fix as necessary - someone should really look at
the result when it is available.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_13_28_55_+1000_R+E=Th+e9.zbYQ5C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVpj3AAoJEECxmPOUX5FEEEsQAIQq57bYwKgmkomsTGQ9OEOB
A2i1jO08GENDFXjGNC/VHembXdzkZyc5PdKwT/8RL8LdjEpI0LV/7xFJ81MTVlcc
8RGdm/Sdmk9t/5CFlD/rGqPU9N40usDlsUWSh/2moUmh3e7w6yKS5hhW0m9OGG6n
sKm563KeyU1l0jqOLKkPcq8uhm4mqiooXEa/IUWitMVK1F2UBhVYUdutf2Q3bSR2
6N38/ntnqTOMeThDJM+AeZYymkc8mcAH1yPa62cszEPbuSEie4OvGgUYXk8VYYFt
TrUws/PUmv7Pb63zUsJO4qN7bL2o7R63EI0OsJ8YALLkunlQkkizCYwuc6vGDAGY
j3Pwl2AnWAJ0CnRGISB9OtKi47lwDfZYRlqtMSFbZbuNK51SMwER0T0Dt1jIrBXI
UVdj2Du0weMR+qZkZdbh8GVGWnQatu4pv3S14sjz1OPuUKPEi3p0c9cr8ySLmL3Q
2ljqsHdyItXAxWq41rSAA1wkUTwu4w2CpatpPncbCvsbH515r0WNAmq+JtR9lrAU
bNbP68DpK5laj/0EU8Z5OikrIlJQq6cgby7BejDuGYkTuz6YWGW1ZBEnMYupRhhu
n/BLxi797b3EuAS5zWbltFY/9J+AWq+SeIUOfR4WFqAPaRQoLg21dcsljgW0k5Aq
UQ4pnIN1J6BlWF0cLRDQ
=hqPP
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_13_28_55_+1000_R+E=Th+e9.zbYQ5C--
