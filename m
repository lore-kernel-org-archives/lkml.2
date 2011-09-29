Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab1I2VH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:07:27 -0400
Received: from 74-92-214-37-Colorado.hfc.comcastbusiness.net ([74.92.214.37]:36396
	"EHLO zlynx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab1I2VH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:07:26 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Sep 2011 17:07:25 EDT
Subject: Samsung Series 9 seems to require acpi=nonvs to resume properly
From: Zan Lynx <zlynx@acm.org>
To: rjw@sisk.pl
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 29 Sep 2011 14:51:46 -0600
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6ADvmD6w/PXGMB+mUTZG"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1317329529.3151.10.camel@knife>
Mime-Version: 1.0
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20110929/1R9NZI-00055U-Vj-linux-kernel@vger.kernel.org:zlynx@acm.org:74.92.214.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6ADvmD6w/PXGMB+mUTZG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

After being annoyed that the latest Fedora 2.6.40 (aka 3.0 something)
kernels would not suspend/resume on my laptop I followed a Ubuntu forum
suggestion to use acpi=3Dnonvs. This worked, or at least it is working
today with Fedora 15's 2.6.40.4-5.fc15.x86_64.

The system is also booting via UEFI if that makes any difference.

I understand that there is a no-NVS blacklist in the kernel. Should the
Samsung Series 9 be added to this list? Or could it be a different
suspend/resume problem entirely? I ask because resume used to work with
the 2.6.39 kernels, although it was flaky and would sometimes lock up.

This seems to be the necessary information for the blacklist, taken from dm=
idecode:

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
        Product Name: 90X3A
        Version: 0.1
        Serial Number: CZPR93GB301834
        UUID: 249F9300-1DD2-11B2-8000-89C120F0C461
        Wake-up Type: APM Timer
        SKU Number: System SKUNumber
        Family: HuronRiver System

I can make this into a patch if necessary (drivers/acpi/sleep.c,
right?). I am not /entirely/ sure it is the correct fix.

--=20
Knowledge Is Power
Power Corrupts
Study Hard
Be Evil

--=-6ADvmD6w/PXGMB+mUTZG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6E2mIACgkQ1IRuMHS+h7EkFwCdHMJlwTJK0EpMrzY5b+OpHi0E
zmgAnjPLGshHgk/8E+ERGOxiNZs8BYBU
=OL47
-----END PGP SIGNATURE-----

--=-6ADvmD6w/PXGMB+mUTZG--

