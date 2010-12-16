Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab0LPWaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:30:18 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:45222 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0LPWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:30:16 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 17:30:16 EST
Message-ID: <4D0A9164.5070503@afaics.de>
Date: Thu, 16 Dec 2010 23:23:32 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Intel 82915G/GV/910GL, 2.6.36.2: problem with CONFIG_DRM_I915_KMS=y
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

according to http://bugs.debian.org/607300 I have to rebuild 2.6.36.2
with CONFIG_DRM_I915_KMS=y. Problem:

At boot time I get a message "waiting for /dev to be fully populated",
then the screen goes blank and the monitor enters power save mode.
2.6.36.2 without CONFIG_DRM_I915_KMS didn't show this problem.

My grub2 configuration says

	GRUB_GFXMODE=1280x1024
	GRUB_GFXPAYLOAD_LINUX="keep"

If I comment out these 2 lines and rebuild grub.cfg, then the problem
goes away, too. I just get a 80x25 display for grub in this case.


Please mail if I can help to track this down. I would be glad to
help.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0KkWQACgkQUTlbRTxpHjeKHQCfRh5T4VYSNY2iZZJLmbINRjX1
wZ0AmwZQOifgc93O+wPnqPfclVsG98WJ
=Yj2U
-----END PGP SIGNATURE-----
