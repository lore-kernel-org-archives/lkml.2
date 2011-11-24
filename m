Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1KXAxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:53:02 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37711 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1KXAw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:52:59 -0500
Date: Thu, 24 Nov 2011 11:52:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111124115239.ff33728e7e9a99426528c214@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_11_52_39_+1100_YXv==eal1RhbnUy7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_11_52_39_+1100_YXv==eal1RhbnUy7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/tools/mach-types between commit bb9b25f923fc ("ARM: Update
mach-types") from the arm tree and commit 9b7c547f7747 ("ARM: Update
mach-types to fix mxs build breakage") from the arm-soc tree.

The arm tree version is a superset of the arm-soc version, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Nov_2011_11_52_39_+1100_YXv==eal1RhbnUy7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzZVXAAoJEECxmPOUX5FE/+YP/0wQAKhqhPqAGeldojQkxWO/
BdNgXN+NrlVcwYxjbQ13tjEZIAOnUIk2F1Od0JSqJibEtMSj3eS4Pkg8UVrDBhM1
SO1UYkw5CaFFwR90meT3uu0XEmAWG8vWcNub15Ao1sk4YdK0xCY5pNS3ykzZb2AJ
Qg6qN5M8VoLwo8NTUz1ey8jyYbY2lDrxONt1GL6c1NkBWnRbFHFAyX+S8sztTRIh
5o10WEUZVerbpTI3D02oFFM5ol9xyrJLfb87UY+e80otW5Mo4G+6xwyqZtgRW3vu
6ovHqAT360Al/H8xCVbucNAwoYdBimz0+pafwlG2LfnWkrMrJf/KtSTKzSTyU9CE
h5P+gUAzu34dVfEkhLOqc2Fz+mmtnesaaHmjpgbiSUE47BSdEDcVFo8EBHLDKVAG
uPa9/JRJ1ZD714ZQ1q5DKMv351/IZ54tfEKaEPFuRbmC5iHA3aUR5IyHN0P7Vjc0
XFiWu0hrOHXgzqVbJ70rVMFfIujLSbNiBxiVbabwDj/3YYJRearIAYlXLP9oFVke
BigfNCEbDURh4vbT/sSqb42xlSFXTMXxG3+P7a/9T3Ezs0l7o5iuNhG+aKaniN2/
VefBBjEB4/WilG/dqOuPPhe2aJjZmJZCPjwaQrRggwz9x1ysYpNW/1+00HT9GPpQ
tdpMAcVf/GUWmCyjuhV+
=Ia5s
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_11_52_39_+1100_YXv==eal1RhbnUy7--
