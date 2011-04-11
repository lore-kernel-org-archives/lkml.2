Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1DKNiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 09:38:06 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:52396 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1DKNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 09:38:05 -0400
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 09:38:04 EDT
Message-ID: <4DA30096.1070404@ece.ntua.gr>
Date: Mon, 11 Apr 2011 16:22:30 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110407 Lightning/1.0b3pre Lanikai/3.1.9
MIME-Version: 1.0
To: nouveau@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org
Subject: nouveau_pm.c: Build error
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig316FE0E93B62F7E76B40C37B"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Mon, 11 Apr 2011 16:22:37 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig316FE0E93B62F7E76B40C37B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

In nouveau_pm.c, in the function nouveau_pm_acpi_event(), there's no
check for CONFIG_POWER_SUPPLY.

If CONFIG_POWER_SUPPLY is set to either n or m, the
power_supply_is_system_supplied() is 'missing' and there's a build error.=


One solution is to add an #ifdef CONFIG_POWER_SUPPLY along with the
#ifdef CONFIG_ACPI before the function.

--=20
Stratos Psomadakis
<psomas@ece.ntua.gr>



--------------enig316FE0E93B62F7E76B40C37B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2jAJkACgkQid1lVeNDMmBxawCeMImAAaWmMbe9x3/oVjKZzChY
ex4An3XXFBOjMXh0YFmcMMoVMv0KAeOT
=S07X
-----END PGP SIGNATURE-----

--------------enig316FE0E93B62F7E76B40C37B--
