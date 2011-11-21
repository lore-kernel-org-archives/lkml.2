Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1KUX6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:58:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45880 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1KUX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:58:13 -0500
Date: Tue, 22 Nov 2011 10:57:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failure to fetch the cpufreq tree
Message-Id: <20111122105756.08df5d9306102fc31e33dec7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_10_57_56_+1100_E/=X/OTlAaJfpXQC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_10_57_56_+1100_E/=X/OTlAaJfpXQC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Fetching the cpufreq tree produces this error:

fatal: Couldn't find remote ref refs/heads/next

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Nov_2011_10_57_56_+1100_E/=X/OTlAaJfpXQC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyuWEAAoJEECxmPOUX5FEgHQP/2JI5j+nD/w21ui1jDc85VhQ
0hXNgefs41tIMRMZ65re/3tA0MhYQQsG/ELYUw6aoGLIMZhc1ZQMQ7eANu0M+//5
jn+T6R+FdScoPxOeq5W7aRO7g9DMqHiYFoYiAux7RYeaYO8NhfwM3LCe3UoPyuk8
VrpvoYlr2s4kG2yMDxKxpwvY81OfUQB4GFbd6NPhEcxIo8KFU+C0JE3bOig00Dw9
b0F3S8n8zbPSz3/1Yy2ZrNSaYO++wph0KlSkDslxy5mixu5o3SAFrAWzbiwZoMmU
jxUlz+0kcVf8JYw6VnbqwxtUp1CCFfnfPQ3c80BO2QtLkrPcdiAx1KZFHMoiAoAB
qOAQk9RfmkZtIyiPFAIBhQaumgylZEFwv5s1NV7df/0hJMBJMUJE0X1MbaLfNV7C
39y6mByIhsv39P7VB8zUdbHaU4ISHXRGQOPa5QbAnKbDGAPZH2FIF/U87O1ULhex
/+jx25MeKq0Asw8C+br6gNvcmVWQkeUQ+ZT7fnRQkOcHtXlBWW90lL1rgIukre74
66W3TkPadnj6+nCAsmw7zjOPQrdThLsyb4w8UGb47qO6j5Slqpb0qqfVfmRCOPGI
YGEmtzbc1h8M8Ny+jbPFcV9q/wVGAKgup14qLZIrc6ypytap4UcBDXqCymTXrFyr
OboexZGCKoecr50vm6QE
=a6Ee
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_10_57_56_+1100_E/=X/OTlAaJfpXQC--
