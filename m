Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764Ab2FATDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:03:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57680 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965696Ab2FATDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:03:43 -0400
Date: Fri, 1 Jun 2012 20:03:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linus@linux-foundatio.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] x86 platform drivers tree
Message-ID: <20120601190339.GA13930@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Some significant improvements for the Sony driver on newer machines, but=20
other than that mostly just minor fixes and a patch to remove the broken=20
rfkill code from the Dell driver.

The following changes since commit 2d117403b30cd7301af60d7d54b279a9f566d10d:

  Merge tag 'please-pull-mce' of git://git.kernel.org/pub/scm/linux/kernel/=
git/ras/ras (2012-05-31 10:53:37 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to a6c2390cd6d2083d27a2359658e08f2d3df375ac:

  dell-laptop: Remove rfkill code (2012-06-01 12:46:56 -0400)

----------------------------------------------------------------
AceLan Kao (2):
      dell-laptop: add 3 quirks for supporting touchpad LED
      dell-laptop: Add touchpad led support for Dell V3450

Akio Idehara (1):
      toshiba_acpi: Add support for transflective LCD

Alex Hung (1):
      thinkpad-acpi: fix issuing duplicated key events for brightness up/do=
wn

Ang Way Chuang (1):
      Dell Vostro 3350 touchpad LED

Dan Carpenter (1):
      hp-wmi: check for allocation failures

Daniel Drake (1):
      xo1-rfkill: only act when blocked state is changed

Ike Panhc (2):
      ideapad: remove unused define and fix a typo
      ideapad: generate valid key event only

Jesper Juhl (1):
      hdaps: Jesper Juhl: Fix outdated email address

Lee, Chun-Yi (1):
      acer-wmi: add 3 laptops to video backlight vendor mode quirk table

Marco Chiappero (10):
      sony-laptop: use soft rfkill status stored in hw
      sony-laptop: improve SNC initialization and acpi notify callback code
      sony-laptop: support battery care functions
      sony-laptop: add thermal profiles support
      sony-laptop: support automatic resume on lid open
      sony-laptop: add high speed battery charging function
      sony-laptop: new keyboard backlight handle
      sony-laptop: add support for more WWAN modems
      sony-laptop: add missing Fn key combos for 0x100 handlers
      sony-laptop: add touchpad enable/disable function

Matthew Garrett (2):
      toshiba_acpi: Fix mis-merge
      dell-laptop: Remove rfkill code

Mattia Dongili (5):
      sony-laptop: fix return path when no ACPI buffer is allocated
      sony-laptop: generalise ACPI calls into SNC functions
      sony-laptop: use kstrtoul to parse sysfs values
      sony-laptop: additional debug statements
      sony-laptop: adjust error handling in finding SNC handles

Robert Gerlach (3):
      fujitsu-tablet: remove duplicated code
      fujitsu-tablet: convert printk to pr_*
      fujitsu-tablet: correct quirks for Lifebook and Stylistic tablets

Seth Forshee (2):
      apple-gmux: Add suspend/resume support for the backlight
      toshiba_acpi: Only register backlight device when interface is read/w=
rite

Uwe Kleine-K=F6nig (1):
      drivers/x86: mark const init data with __initconst instead of __initd=
ata

 drivers/platform/x86/acer-wmi.c       |   24 +
 drivers/platform/x86/apple-gmux.c     |    4 +
 drivers/platform/x86/dell-laptop.c    |  308 +------
 drivers/platform/x86/fujitsu-tablet.c |   34 +-
 drivers/platform/x86/hdaps.c          |    2 +-
 drivers/platform/x86/hp-wmi.c         |   10 +
 drivers/platform/x86/ideapad-laptop.c |    9 +-
 drivers/platform/x86/sony-laptop.c    | 1560 ++++++++++++++++++++++++++---=
----
 drivers/platform/x86/thinkpad_acpi.c  |    2 +-
 drivers/platform/x86/toshiba_acpi.c   |  141 ++-
 drivers/platform/x86/xo1-rfkill.c     |   13 +-
 11 files changed, 1447 insertions(+), 660 deletions(-)


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/JEgsACgkQ7Hkv8l1YiTs3wwCgjohOuZYiIhrXglgbrV7Nri1e
uQoAnAr6bPhNIFAxRyVNS6sWbQenx4AZ
=jBAr
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
