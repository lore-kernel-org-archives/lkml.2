Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0HDI1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:27:24 -0400
Received: from clegg.madduck.net ([193.242.105.96]:58717 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab0HDI1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:27:21 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 04:27:20 EDT
Date: Wed, 4 Aug 2010 10:19:34 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Penelope Christine Leach <penny@mjollnir.org>
Subject: Failing to read drive: "Very big device. Trying to use READ
 CAPACITY(16)"
Message-ID: <20100804081934.GA9185@piper.oerlikon.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Penelope Christine Leach <penny@mjollnir.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.33-2-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear kernel people,

We are trying to access the harddrive of a decomissioned laptop.
It's a Western Digital Scorpio Blue 320Gb SATA drive (WD3200BEVT=B9,
625,142,448 sectors).

When we attach it via USB, however, the kernel fails to read its
size and assumes it's 2**32 blocks long (2 TiB):

kernel: [ 2466.318829] scsi 9:0:0:0: Direct-Access                         =
  PQ: 0 ANSI: 2 CCS
kernel: [ 2466.319359] sd 9:0:0:0: Attached scsi generic sg9 type 0
kernel: [ 2466.323641] sd 9:0:0:0: [sdh] Very big device. Trying to use REA=
D CAPACITY(16).
kernel: [ 2466.325387] sd 9:0:0:0: [sdh] Using 0xffffffff as device size
kernel: [ 2466.325395] sd 9:0:0:0: [sdh] 4294967296 512-byte logical blocks=
: (2.19 TB/2.00 TiB)
kernel: [ 2466.326060] sd 9:0:0:0: [sdh] Write Protect is off
kernel: [ 2466.326063] sd 9:0:0:0: [sdh] Mode Sense: 00 38 00 00
kernel: [ 2466.326066] sd 9:0:0:0: [sdh] Assuming drive cache: write through
kernel: [ 2466.333816]  sdh: unknown partition table
kernel: [ 2466.360579] sd 9:0:0:0: [sdh] Attached SCSI disk

If we attach it directly to the SATA bus, it is not detected.

Is there anything we can do, or is this drive simply lost?

=B9) http://www.wdc.com/en/products/Products.asp?DriveID=3D377

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
who's general failure, and why's he reading my disk?
=20
spamtraps: madduck.bogus@madduck.net

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkxZIpIACgkQIgvIgzMMSnX9LwCghvAVPnUJ5FSdD0M0m1pb2X14
SdUAoNRh8gmPdaw0CUlBZNBV8lMAMYRS
=Aj4J
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--

