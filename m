Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1KDPSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:18:25 -0400
Received: from static.4.202.46.78.clients.your-server.de ([78.46.202.4]:44666
	"EHLO alpha-unix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KDPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:18:24 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Nov 2011 11:18:24 EDT
Message-ID: <4EB4006F.3040602@alpha-unix.de>
Date: Fri, 04 Nov 2011 16:10:39 +0100
From: Michael Basse <michael@alpha-unix.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernelpanic on eeePC and MSI Wind (both using rt2800pci) with Linux
 3.x
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi everyone,
first of all, i hope that this procedure is the correct one for
reporting issues with the kernel.

Because of 404 on
https://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html please
forgive me when not everything is as you would suggest.

Me (and many other) ubuntu-users are facing issues with different
Version of Kernel 3.x. As it seems all users are using "rt2800pci" for
there wifi.

Model: "RaLink RT2860"
Vendor: pci 0x1814 "RaLink"
Device: pci 0x0781 "RT2860"
SubVendor: pci 0x1814 "RaLink"
SubDevice: pci 0x2790
Driver: "rt2800pci"
Driver Modules: "rt2800pci"

As it seems, the panics are happening more often, when on battery.

Also, this bug never happened on 2.6.38-x, Just with 3.x

My initial bug-report can be found here

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869502

Because i am also facing the kernel-panic with 3.1.0-0301rc9-generic
(which is not a specific ubuntu-kernel) i think its an upstream-bug

Here is a summary

3.0.0-11.18 = no panic after (3-4 days of testing)

3.0.0-12.19 = panic (3-5 days of testing)
https://launchpadlibrarian.net/82161301/IMG_20111006_222737.jpg (no
rt2800 in the text)
https://launchpadlibrarian.net/82196440/IMG_20111007_103327.jpg (no
rt2800 in the text)

3.0.0-12.20 = panic (10-10 days of testing)
https://launchpadlibrarian.net/82558459/IMG_20111011_211226.jpg
(rt2800 in the text)
https://launchpadlibrarian.net/82620705/IMG_20111012_163536.jpg (no
rt2800 in the text)

3.0.6-030006-generic = panic (14 days of testing)
https://launchpadlibrarian.net/84309173/IMG_20111103_032854.jpg

3.1.0-0301rc9-generic = panic (14 days of testing)
https://launchpadlibrarian.net/83329981/IMG_20111020_231054.jpg (no
rt2800 in the text)

for the last panic i a some dmesg and syslog-infos

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869502/comments/67


Additional Screenshots from others users can be found in the bug
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869502

Please let me know if you need further informations from me.

Greetings from germany

Michael Basse
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOtABuAAoJEMIajL8dFT4GXCAIALGXZ/K8EwTxHeYdrZ0m5ORR
2P3MThbmJF/LrxN/qPFYWTIrck9qLm62pf7o5MeyY5gmIz7ToS+8caj2gcwBvy62
m5X6+jjWz+h3IldkzwxgbWPiu0GO5DXF8lJVfcx3ATnjpRUwe7SNkC2Sex4sqiXY
1thTER7ckeAt1PnImEKHPTwYW0Sc97FoyTYTUfwc4Pky7Y8dZSsCk4uB1cdxyH1t
MfRT+mgNbUHuv0+aXwdGY0EiIttfyLq0qq2LmGVpqVcWcPJNuiCdaafIPdVCrqPE
uBmtKDnnCxy+jNRjnPVk/FRknZVG0uNTDQ2YulbaOVhcHrGYUlQVJlmUSx5qk0g=
=SIF1
-----END PGP SIGNATURE-----
