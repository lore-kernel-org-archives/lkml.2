Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2F2DiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:38:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34168 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2F2DiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:38:16 -0400
Date: Fri, 29 Jun 2012 13:38:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Kumar <vipin.kumar@st.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120629133811.31f56e9778b856f59d77ecd6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_13_38_11_+1000_Vsc_C/h/8hSk7e1Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_13_38_11_+1000_Vsc_C/h/8hSk7e1Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/spdif_receiver.o: In function `init_module':
spdif_receiver.c:(.init.text+0x0): multiple definition of `init_module'
sound/soc/codecs/spdif_transciever.o:spdif_transciever.c:(.init.text+0x0): =
first defined here
sound/soc/codecs/spdif_receiver.o: In function `cleanup_module':
spdif_receiver.c:(.exit.text+0x0): multiple definition of `cleanup_module'
sound/soc/codecs/spdif_transciever.o:spdif_transciever.c:(.exit.text+0x0): =
first defined here

Caused by commit cdf605255c2b ("ASoC: spdif_receiver: Add support for
spdif in Audio Codec").

I have used the sound-asoc tree from next-20120628 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Jun_2012_13_38_11_+1000_Vsc_C/h/8hSk7e1Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7SMjAAoJEECxmPOUX5FEbagQAJU9nSW3RkeVB+/cKA/aYqJe
vbMK9B9uB7KIhsXUWPG/tMvgCepiV7wyWRtvQc+4RYEBw0+3W1LSpMIcizHpkAjz
RZWGbA0aWPEUFocWlaQH8QWg6jxMowrdCSKfOf5tVihfT24jw6atZ0XErnaXPBiH
i9HyYvYEax/bhwfwAC1iQQem1aGNMyyv7cMD5NkndQpu1WUUZWURn6sgfbxyU4Kc
2gb4hEZL9ycQxnj/BJB8kf6H7rdpDIpypLGq3K4InkufxwVIDBjaQCuUiB2D9JpF
p2RCfpHLFNlqCS/1rOoIc54IDN+tv2VEjsp61GVClIV7CPfmTLV9JAcoYYJANvQO
FnwIErZnJKcWYg4NNCiTKShW12V94j8hwzw3kAM10G57rIyCH0ljBxOOrFhWASGY
BQ9WOphYXB9bsoo5FGFHCQF4ijzhUULFPLFrYm7qoyT3l97qxxQ5NZBOYS8Vph7T
TGjfkzLdasryenTI6k043EQUSy2jH057RUaODX9AfSFxOwBKGsxZ7l98biQ5i81V
3ARud+uqC9bLoK4cz42ZKyPNu18XyHDnQwYvK8y5VCRhiu0Qx5ooZGRp1IfP3ssD
rbjOsX1CcMj5PbZCrdoIxokpsSnfC97uoz5DqFcx66ycWTdFTnBOLueVmZAEIAf5
yyxRe7+pYaZuUjTpKh5K
=HsCp
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_13_38_11_+1000_Vsc_C/h/8hSk7e1Z--
