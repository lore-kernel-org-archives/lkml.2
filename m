Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1JNSfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:35:15 -0400
Received: from imr4.ericy.com ([198.24.6.9]:40433 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1JNSfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:35:13 -0400
Date: Fri, 14 Oct 2011 11:33:39 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.1
Message-ID: <20111014183339.GA24292@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:

  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Jean Delvare (1):
      hwmon: (w83627ehf) Properly report thermal diode sensors

 drivers/hwmon/w83627ehf.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOmICDAAoJEMsfJm/On5mBVMAP/0EuoG5Blw/NJdepKmRBjbrU
WYcER19T5T4c65qC5NBbrXBI5m50yH9CB0cQXnNdzQe06daZbdMdvamsCZCJUoHQ
WPKj1j6TNkhbnvVkso8hZzAqP7dbh+t6qdVtY7CSNlkm9tWHNpUoOr0Kfmizii4r
/BWXa+zWyPWuIm5pynZ2bJE8G/zB1J5MDakItYj4aEEpQSCqqQyDvXeKQGa7vg0V
HZMYZ9sEGZvvVk9QdXuyONa/BoTs66jWXHR/43djP+AuxmPk3u+7435kEHwzLkBX
X5Vy96wnla2ex+3BW3PVidPaYooYyUANPQRJ8jmcTFrAA62xzyWo0Z2AlXbdPVAh
WcpUEvtSTqs0gwF2TK8BuNVIzFQtQRt6qxYfwcfBCOfGo6/5tJWjWxrTaGhci78p
jyq4iMN+LZX2rk0XIrgvYkSHewMW4eZH9c2FJCTz+kHvzldpmDj1rZ21cIm+bF9r
8gyDkCHwdB6MXCQHf//QMI0llUr7cru4WTr8Kt7Dx2uiFUS+IevJtpfbGArM/sYx
FHkyL2yqgmE0VwujrKuuM5Q1AuE/US5O+puGb9FPebVWa+9sFmZGlAJkjqQc/VQl
j8X1N04+RIYnpBs5QElG1XQtV4zY0YRGO8EZ7MmGutkDPdrbHVN5p7MFcCJCBFB5
7HFDo2NIYbFeddpIBJkx
=NCrD
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
