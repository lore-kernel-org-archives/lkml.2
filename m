Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab2LAMHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 07:07:33 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:32825 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2LAMHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 07:07:32 -0500
Message-ID: <50B9F233.5040902@gentoo.org>
Date: Sat, 01 Dec 2012 07:04:03 -0500
From: Richard Yao <ryao@gentoo.org>
Reply-To: kernel@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121128 Thunderbird/10.0.11
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org
Subject: My SD Card Reader cannot read SDHC cards
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDAE218D89209E0342C51F2B9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDAE218D89209E0342C51F2B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have the following SD Card Reader:

http://support.dell.com/support/edocs/monitors/2405fpw/en/about.htm#Card
Reader Specificatoins

It is identified as the following in lsusb:

Bus 002 Device 007: ID 0424:223a Standard Microsystems Corp. 8-in-1 Card
Reader

I have a LG microSD Card adapter that came with a LG Optimus V and a 4GB
Kingston SDHC microSD card. I also have a 2GB SDSC card that works. When
using the microSD card with the adapter, nothing immediate happens. The
following messages appear in dmesg when I do `fdisk -lu /dev/sde`:

[ 2075.817148] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2106.777063] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2116.973078] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2133.171089] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2133.369081] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2143.565096] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2143.688984] sd 10:0:0:3: Device offlined - not ready after error recov=
ery
[ 2174.889137] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2185.801154] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2196.777168] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2207.785189] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd
[ 2238.825093] usb 2-4.2: reset high-speed USB device number 7 using
ehci_hcd

Would someone provide me with a brief description of where the code that
talks to the SD Card reader lives in Linus' tree and how it works? I am
not familiar with this subsystem, so I need some pointers before I can
look into whether or not I can make it work.


--------------enigDAE218D89209E0342C51F2B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQufI6AAoJECDuEZm+6ExkVp0P/1qsgTLJK2cK1qu3o4ycrvGX
Dk3AxPlBFSajvk/kADSyEH8x0ECsLeZRufX3ElEXmNawShJ1jL9lUaZowobpnVDo
dBWfZNdPIC5wEMRyUaIR/14ubU/6vdZVTB5yH4Bx4gA4bx+OQuBQimxKU8MnmBZO
utpw9WsBfCF8c1LlGoemJgV6b1Bvxs+ccTPGNOME6YyJ3c1bJCocbZu6Pl808Cub
ViheXmdTE8LDtfbgd5bTrXVIRalqrjJ0tlnaOIq9VMFTP2hrINAZLSHgljnuVzX1
tvdfTZp0CBLAIM5txuQSqkvrB5BiOdJcMfBw+CHBo5ywsT/7BsHjbgKhC7YdsFwK
iGb+P0nT/C4i5I/wnZHSbJ2QCn3Q3aBzPAKNadJqZEr0ccs+JJNlQ3nAY5AmbF6S
G/R36YYfLtPOqQ6r+D6/hYSPX8fXVaPKGsQcz0c+l4pW5vVw+2CHU4M/gAh0oDlV
uHcQzL1VcuVJJKmM0SkukKhVqQ+ENPlyW43gTo6sHqzYvw0BifvWujvaQVIJmen+
eC1URcvPd9PLOgBTMESPGhm80Jrx5Z9Xkm+KcXTczJXrxu7z5bbs5lIJAOUAxsn8
wHtDYqG4QM7GN8ZogQMGKuIz5sebrAM8KEvuRPJlMLDaYVC5DjSGo55cD72epbFr
gi8n2iLZg4k010w5U/l6
=/VKd
-----END PGP SIGNATURE-----

--------------enigDAE218D89209E0342C51F2B9--
