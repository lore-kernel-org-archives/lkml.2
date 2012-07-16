Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2GPMpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:45:54 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42542 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2GPMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:45:51 -0400
Date: Mon, 16 Jul 2012 13:45:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform tree for 3.5-rc7
Message-ID: <20120716124547.GA10447@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Small fixes to a couple of drivers plus a slightly larger number for=20
sony-laptop that the maintainer thinks are appropriate, most of which=20
fix problems with the earlier 3.5 updates. These have been in -next for=20
a while without complaint.

The following changes since commit aace99e57c90353a51952e9dd1f6f110eec30d15:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel=
/git/mchehab/linux-media (2012-06-25 14:53:09 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to 88ca518b0bb4161e5f20f8a1d9cc477cae294e54:

  intel_ips: blacklist HP ProBook laptops (2012-06-26 14:43:53 -0400)

----------------------------------------------------------------
Dan Carpenter (3):
      sony-laptop: fix sony_nc_sysfs_store()
      sony-laptop: fix a couple signedness bugs
      ideapad: uninitialized data in ideapad_acpi_add()

Marco Chiappero (1):
      sony-laptop: notify userspace of GFX switch position changes

Mattia Dongili (5):
      sony-laptop: use an enum for SNC event types
      sony-laptop: store battery care limits on batteries
      sony-laptop: add lid backlight support for handle 0x143
      sony-laptop: input initialization should be done before SNC
      sony-laptop: correct find_snc_handle failure checks

Takashi Iwai (1):
      intel_ips: blacklist HP ProBook laptops

 drivers/platform/x86/ideapad-laptop.c |    6 +-
 drivers/platform/x86/intel_ips.c      |   22 ++++++
 drivers/platform/x86/sony-laptop.c    |  136 +++++++++++++++++++++--------=
----
 3 files changed, 114 insertions(+), 50 deletions(-)


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlAEDPsACgkQ7Hkv8l1YiTtaQgCbBvMmWv3CjqohilYJ+l8C+3h9
D/wAni9BQ581b53+9lSiP29CmuLSstKJ
=MJRl
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
