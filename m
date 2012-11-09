Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2KIETI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:19:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39985 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2KIETF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:19:05 -0500
Date: Fri, 9 Nov 2012 15:19:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>
Subject: linux-next: build warning after merge of the final tree (akpm tree
 related)
Message-Id: <20121109151903.19728e9a7a8fe9e509bb523e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_15_19_03_+1100_Lu5a4.Ib7=xRhmj="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_15_19_03_+1100_Lu5a4.Ib7=xRhmj=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
produced this warning:

arch/arm/mm/mmap.c: In function 'arch_get_unmapped_area':
arch/arm/mm/mmap.c:60:16: warning: unused variable 'start_addr' [-Wunused-v=
ariable]

Introduced by commit "mm: use vm_unmapped_area() on arm architecture".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Nov_2012_15_19_03_+1100_Lu5a4.Ib7=xRhmj=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnIQ3AAoJEECxmPOUX5FEOOIP/16I0DWBS/t8NFnN6C/TPT3l
CiDlfNej45s87xXA1jh5xx1EhQtCufoL6n1Yrsxea9HsHfa+PaswDsEExBazfA01
rRXGEjl/FixLvfreyUjhdhB9jYJxwaU/yKPXqmH3SBnf132csWEu5blJAhT2Fmac
3evEahgYQUiQtJ8DML8uwnznd3I2MtsB9Ibl/80fsx9vVnR8sIcntCRCuhHva1BS
BSNK0mRcusdLX5WTvhd+mpPXno43qRyi3PlhK8uO2nrS10dFGzrBZiGP6cCs/sYS
DrM74XgrMHl2RY/1MtgqDhSUo2YcavZOqsC2yhshU4DW+srGBZkkVTPHgKcrkjvp
bfw/xGbE+kCuTi39RBrbQ7dFtpRrL9FjIvmu6x5Q7WJynsSeG6FRc8Px5hUaw31X
oXygGgHSGhqo0k7t/JCy1z3eJiXWpO5da1lynL4wnKbNp6jj794pCyRrfPGB2lu/
6gEmS6PSl+ednImvWUhSbndqAlVS0++GSgsi/Yd6os5/NO1TjRn1xB93V4DQaLWP
vbY0plxhVuzPZs1aVI143lTbnOtwhxKcvRjsdNw0uKxX/mNocO4d3KvLOJEImThO
XEdk1SdKYfqvxPNLO3NRHy5ovIfjqU8XDgnPfflQTjGrZ8Z6OXumgw4RSwq35Qtx
NE9iXncOhXH6mQkX/Cly
=0aGI
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_15_19_03_+1100_Lu5a4.Ib7=xRhmj=--
