Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0DZRHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:07:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:34401 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751125Ab0DZRHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:07:06 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18SFkIwWKEShq6v2X0bjsgOZIEmqFksIoWNSrALyP
	ruF+SUHuXcUCZM
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: should the resoltion of a closed lid of a docked ThinkPad be considered
Date: Mon, 26 Apr 2010 19:06:44 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33.3; KDE/4.4.2; i686; ; )
Cc: "linux-acpi@vger.kernel.org" l <linux-acpi@vger.kernel.org>,
       linux-video@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004261906.45251.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

there's a different behaviour between 2.6.33.3 and 2.6.34-rc5 observed at a 
ThinkPad T400 with intel graphic GM45 .

If it is docked and the lid is closed (1440x900) and an external DVI monitor 
(1650x1080) is connected at the docking station - the dmesg of 2.6.33.3 gives:
	Console: switching to colour frame buffer device 210x65
whereas 2.6.34 gives:
	Console: switching to colour frame buffer device 180x56

Furthermore X differs in the fact, that 2.6.33.3 sets the external monitor to 
the expected resolution:
	(II) intel(0): Output HDMI2 using initial mode 1680x1050
whereas 2.6.34-rc5 sets it to the (unwanted) lower resolution :
	(II) intel(0): Output HDMI2 using initial mode 1440x900

Now I'm wondering whether this new behaviour is wanted - and if not - which 
mailing list is the correct one ?

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

