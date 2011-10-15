Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1JOPLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 11:11:12 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:49742 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab1JOPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 11:11:11 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Oct 2011 11:11:10 EDT
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20121.41239.485545.656633@elektron.ikp.physik.tu-darmstadt.de>
Date: Sat, 15 Oct 2011 17:04:55 +0200
To: linux-kernel@vger.kernel.org
Subject: How to blacklist a usb_storage device from attach to the
   usb_storage module
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.10.15.145117
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The STxxDiscovery Modules are affordable small boards with an ARM Cortex3
microcontroller, Pins available at break-out headers and another smaller
Cortex3 with USB connection, providing a so called STLINK. The STLINK(V1) is
implemented as a mass storage device and the main STLINK functionality is
implemented as generic scsc commands. The mass storage implementation is
deeply broken:
http://code.google.com/p/arm-utilities/wiki/STLinkDownload (Usage)
Attaching the device causes tons of messages and the device is only
available minutes after plugging.
I now have rewritten linux stlink implementation to only use libusb. Now I
need a way to selective inhibit attaching the device to usb-storage. As a
first mean I can inhibit loading the usb_storage module, but that affects
other usb storage devices. In the long run, probably some modification in the
usb storage kernel code is best, but blacklisting there will need time to
propagate to the kernel tree and back to the distributions. So a way to
runtime blacklist is needed too. 

Any hints welcome.
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
