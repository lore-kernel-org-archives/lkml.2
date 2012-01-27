Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2A0Rzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:55:45 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:50656 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751172Ab2A0Rzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:55:44 -0500
Date: Fri, 27 Jan 2012 09:55:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/21] PCI : Calculate right add_size
Message-ID: <20120127095541.7c7b806d@jbarnes-desktop>
In-Reply-To: <1327140517-14811-2-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IbMCG6GkERck/IK8/GmfpI8"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IbMCG6GkERck/IK8/GmfpI8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:08:17 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> During debug one SRIOV enabled hotplug, found add_size is not passed prop=
erly.
>=20
> the device have devices under two level bridges..
>=20

Ok applied 1-5 so far, looking through the rest now.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/IbMCG6GkERck/IK8/GmfpI8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIuUdAAoJEIEoDkX4Qk9h6aMP/RIHBD47FQLiAZt1AJ5axWr0
6il60zdgzj8ARlssYskDU0yhEzYqgjmVm9Avb5wfTBBWq2ndZdIH+EUwNDPdeSVN
woNXf8KFrFcWvH+4En02c956mWSI7zNKjDyAj3jR3AQpR+cW6y8gQ5xt5Q70UIJi
QYOc3pAl8aj9sD8Z8DG/N+UCpgQOcndpCgiU/jfKkTxXu8TdyznrqLUMX7DBZWlW
1Iu4q28/lWIJFb6gnknHiujJ8DJAvbANolXl62kxt+C5thGNcrqVALhgqJuugXI+
jmbE3Ax4GL2bkgF93m3bgKGqY9Cww1zsIONpaDIGxjizYtSc2mB9J7/GWKzKu9Zx
z7R+tQnFS01lprDaxJBtbU6hT41/I0SlOIfyVMgijcHTBGcBPcsl3VoQhzpHbsJu
m8hAf6KikKZiUAcg42PgYE12oyf+rv8PU9xCgK48AIEq+3NQC77HPVhRgN3YER8+
wHr0/mPpb9TJ7Z5P204kpsAkVNImCc5fu9Kp2/oLtPQV+nkApkLjxQ1px+LpsK+c
VjZWMyaayLNu0XsXV0PfSTZ74zdjRkHzf4AZ78Z5j2VcQ0ArJjt6H1D2T+SlWJVI
/X4PU05mfWsD42E2RpWN4hNw0o6xhgj8vc9XcrhjGynJZ6ahyXg+DXrWy12G1jRr
0tURAjMMw1Yr1aVQcz7n
=QSur
-----END PGP SIGNATURE-----

--Sig_/IbMCG6GkERck/IK8/GmfpI8--
