Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2EJHeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:34:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54235 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2EJHeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:34:12 -0400
Date: Thu, 10 May 2012 17:34:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: manual merge of the staging tree with the driver-core
 tree
Message-Id: <20120510173401.263f10f33f918bfc9e0bec88@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_17_34_01_+1000_D08RUPVxfxks/EqD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_17_34_01_+1000_D08RUPVxfxks/EqD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/misc/Makefile between commit 6a7e2618b3db ("misc: MAX8997: Remove
max8997-muic driver") from the driver-core tree and commit ffc2825c2942
("Staging: mei: move the mei code out of staging") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/Makefile
index b26495a,0f6af6a..0000000
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@@ -48,3 -48,5 +48,4 @@@ obj-y				+=3D lis3lv02d
  obj-y				+=3D carma/
  obj-$(CONFIG_USB_SWITCH_FSA9480) +=3D fsa9480.o
  obj-$(CONFIG_ALTERA_STAPL)	+=3Daltera-stapl/
 -obj-$(CONFIG_MAX8997_MUIC)	+=3D max8997-muic.o
+ obj-$(CONFIG_INTEL_MEI)		+=3D mei/

--Signature=_Thu__10_May_2012_17_34_01_+1000_D08RUPVxfxks/EqD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq29pAAoJEECxmPOUX5FEhncP/jXTygwnwTxQFY04nKolmyw+
e+dD/Z9lzRix4Yof5+k2gmGPyzfg5wXxTnZQTcaHtIL+5fd5H8kcpV2qLOycMIiv
UCaXRZwUSLnLmVI2uAbNex+hU7o8jb2MmLXu773AZVycVVw2G63MClkWXfSPERKo
lpsL5BZC1snlli5xNsSzTDmsR/n1nGTzco7X5suWxUF6H5c9DZF42jsRB2BU9rrX
nQyZ/P0VcFSkP6qr3K7DkXh1InhpztQ7mPulQqOsHbwhSP0HHpgRtUZNtr9kIGUA
KOnkP7HdYHoGsEDfZL5cDha8k3VEK9yDqPY4wXFZoKkOVuVRJ2N6gStaG4flb8LP
nuSjLgjXMBpdSjDl0y4WC8FgCjHsfgTerdhmmva+kvPxCGRYItD9AgYQGX2Az5Z3
/v1/7UEPASpmmMUFiddnGRwfzktlDXfodo+yzG+3Mspfkh9ZZDohjuM+MxcgSqXV
YE/bSz15Dc3vF1RR5L9SobZvk2oiusmpuXjlw5xlzfTZPuHXNSuqLHOQ97fOI2Pw
ncVtdly9xYiuS+wVBFiKXobtDitSZP9I/iRJEfcCflpjEQKHUvltqL/4K2F654/1
qL8VKzoHo3IWTXHWkMWWz55PGuC1ffutyE8JJTDJsOCNAxZqClKNZNLPvJf/ecl5
J0DpQe12XRF1Y5rgksa/
=r3UI
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_17_34_01_+1000_D08RUPVxfxks/EqD--
