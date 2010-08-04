Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0HDHNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:13:23 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:54608 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0HDHNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:13:21 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ide@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: 2.6.35 vs. 2.6.33: ata_piix does not find any device after piix is loaded
Date: Wed, 4 Aug 2010 11:11:15 +0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.6-desktop-2mnb; KDE/4.4.95; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1355273.PdO78WvsS6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201008041111.16151.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1355273.PdO78WvsS6
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Due to minor glitch in initrd generation I had both IDE and PATA
drivers included:

{pts/1}% lsmod | grep piix
ata_piix             =20
22460  0=20
libata                193241  4
ata_generic,pata_acpi,ata_piix,ahci
piix                    5408  1

ide_core              116373  3 ide_cd_mod,ide_pci_generic,piix

With
kernel 2.6.33 it gives me DVD as hda and HDD as sda. With kernel
2.6.35 ata_piix does not find any device after piix had been loaded
effectively leaving me without root.

Is it intentional change or
should I fill a bug report? This is Dell XPS M1330 notebook with
single SATA disk.

00:1f.1 IDE interface: Intel Corporation
82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
00:1f.2 SATA
controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI
Controller (rev 02)

I can provide additional information on request
or attach to bug report.

TIA

--nextPart1355273.PdO78WvsS6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxZEpQACgkQR6LMutpd94y13wCfRXPSSZa8XSjJV6domdJ38/rz
G5wAnRsXDy6c6ilFY17xtiD0uOAIBnM4
=X0lw
-----END PGP SIGNATURE-----

--nextPart1355273.PdO78WvsS6--
