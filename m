Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1BIEMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 23:12:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56885 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab1BIEMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 23:12:13 -0500
Date: Wed, 9 Feb 2011 15:12:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the workqueues tree
Message-Id: <20110209151204.efef8089.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Feb_2011_15_12_04_+1100_kYJiCje4O+7mAkv7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Feb_2011_15_12_04_+1100_kYJiCje4O+7mAkv7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the workqueues tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/built-in.o:(.toc1+0x14c0): undefined reference to `system_freezeable=
_wq'

Caused by commit de62c151df9b6568c67977920267392c432f340a ("workqueue:
add system_freezeable_wq").

I have used the workqueues tree from next-20110208 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Feb_2011_15_12_04_+1100_kYJiCje4O+7mAkv7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNUhQUAAoJEDMEi1NhKgbsYEYIAIdIQJWpjoJt4geJtzJT3wDo
6g/HtsN60dXQ/XL/wkn8WGGthUpWMUn0qsaTf8mfrhkTEBpcITeQ5p01YYLmUahF
u8/gy9I0tjY68Jznoz5q5Kz3H1Dqpz381ZdRxvZ476TRXf9lUcKaa16PNs/Kdwnb
abNRVIqeiwsUKXqNiFP7gSDSGQUABQzYufKzkyratlPI2Zz2qyhiiL/zJUDBlM4Z
S35LSian0pyODmtMqLH549Y9PBk1qH3PbmXaW+44Xc0+QeQoa+TUIH8JLQsFUk+0
DdVJleCUs85bmzPY0oCHxvEyGyPS1LaqDZJrSwB7MZ+F41lSh63AaKaEMLPePQ0=
=rBgg
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Feb_2011_15_12_04_+1100_kYJiCje4O+7mAkv7--
