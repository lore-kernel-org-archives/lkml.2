Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1LQR3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 12:29:42 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49759 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751936Ab1LQR3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 12:29:41 -0500
Date: Sat, 17 Dec 2011 09:29:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20111217092935.2c2e075e@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jqot3q7I0bAoN0p2nzClItU"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jqot3q7I0bAoN0p2nzClItU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit
8e8da023f5af71662867729db5547dc54786093c:

  x86: Fix boot failures on older AMD CPU's (2011-12-04 11:57:09 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci for-linus

Just a few regression fixes.  We have a fix for the extra msleep you
pointed out last time as well, but I was saving it for -next since it
took awhile for Kenji-san and Yinghai to settle on something, and it
changes a core behavior.

Ajaykumar Hotchandani (1):
      PCI: Set device power state to PCI_D0 for device without native PM su=
pport

James Bottomley (1):
      PCI: fix ats compile failure

Rafael J. Wysocki (1):
      PCI hotplug: Always allow acpiphp to handle non-PCIe bridges

Ram Pai (1):
      PCI: defer enablement of SRIOV BARS

 drivers/pci/ats.c                  |    1 +
 drivers/pci/hotplug/acpiphp_glue.c |   30 ++++++++++++------------------
 drivers/pci/iov.c                  |    7 +++++++
 drivers/pci/pci.c                  |    5 ++++-
 4 files changed, 24 insertions(+), 19 deletions(-)

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Jqot3q7I0bAoN0p2nzClItU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO7NF/AAoJEIEoDkX4Qk9hwTwP/RFGF084QRkSNWHh8MKOyyHk
GvK/WsJqzk+XnBNHsBMMWUrnDchctWhoSnVAC3gnpeq+AReJRbTfjWKMSCwsyRkB
Fs8xeahL/nxUBRPph99cU6d8e1dGHos9ap3a4xU1nH2FgDUNffuzKYRXk0uYCzGn
WktLI9g6gWOSbT/dCp3WOAMh9fL9qCPpXsjzEOphWFx89CLxQHmZjtdrCMsOte9S
sv+0uAdEvmG5mjXRscB5p4O9npvVNqXqQXeZO+5ekRQbfRWIy9M1V64x6KQOc1NZ
r9uiXqJ4kEx7NhLWrV3VAD9DJh9oT4ebfEVGf8mZW2TuWDKmxWxzuDqFkJ9lu4+u
b/2qomFENf6FvVAw9xIoWFzgTzMPkDa6nsra+C/ohnX/9nGcxA2BL7cfry9Zy1ba
gxKpsi5AThdihOvL/yU4l+tiHsXG961F+ULyyWiG6LbtqQRa1UO9Se8Wv7xb7mL2
TshuhvmhmzdcLezJq7E62Oo5qErb//zlacLTKiiLwmB0X6GX1B3l6vSpEesTLHY/
O914vZTcIyu9ENxftOzFiWa4bocN/NOawlIHrQU9CbdRFnOQvDdKAftlK6qYJRpT
uRz9xFmBfoXe9GsKmMttxizbMgN2Adt5Gvqz8+RLU136LgdCKF2MupBvMg+d9Mmr
T3C7T3mE3E1zL/cf5reH
=KAh2
-----END PGP SIGNATURE-----

--Sig_/Jqot3q7I0bAoN0p2nzClItU--
