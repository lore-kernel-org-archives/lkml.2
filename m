Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1DNWZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:25:35 -0400
Received: from helios.rbi.informatik.uni-frankfurt.de ([141.2.1.4]:36429 "EHLO
	helios.rbi.informatik.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab1DNWZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:25:34 -0400
X-Greylist: delayed 2047 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 18:25:33 EDT
Date: Thu, 14 Apr 2011 23:51:18 +0200
From: Martin Teufel <teufel@informatik.uni-frankfurt.de>
To: linux-kernel@vger.kernel.org
Subject: bug in radeon driver module of linux 2.6.38 (since 2.6.35)
Message-ID: <20110414215118.GA30387@hekate.rbi.informatik.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I encountered a bug in the radeon driver module of 2.6.37 which still
exists in 2.6.38.
I have a mainboard called M2A-VM which has VGA, DVI and display port as
graphic output ports. When I boot Debian GNU/Linux with Linux 2.6.37 or
2.6.38 I get every 10 seconds:

radeon 0000:01:05.0: HDMI-A-1: EDID block 0 invalid.
[drm:radeon_dvi_detect] *ERROR* HDMI-A-1: probed a monitor but no|invalid EDID

This error message is spamming to tty1 (and because of my configuration
to ttyS0 too). With radeon.modeset=0 set, I get rid of this messages by
disabling KMS for this driver.
This behaviour is also described here:
http://ubuntuforums.org/showthread.php?t=1607778

My board has no HDMI port btw. - I think the driver should either not
search for the HDMI-A-1: EDID block 0 resp. a HDMI connected monitor
while the board has no HDMI port at all or just probe for it once
instead of every 10 seconds. I don't see any reason for probing every 10
seconds but I don't know if there is one.

Please note that I'm *not* on the mailing list, so please send me a CC
of your answer(s) - thanks.

Regards,
Martin

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2nbFYACgkQK1fQl8zzxa6R7ACbBn3kF93+WFL6MOmMsbUjv/Oa
Z0UAn0xpsueAaypwTPs/tkKqJPIvjf+F
=6Mng
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
