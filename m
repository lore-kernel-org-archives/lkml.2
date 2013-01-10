Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3AJLYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:24:51 -0500
Received: from plane.gmane.org ([80.91.229.3]:34218 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3AJLYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:24:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@vub.ac.be>
Subject: xhci module fails when booting in UEFI mode
Date: Thu, 10 Jan 2013 11:15:56 +0000 (UTC)
Message-ID: <kcm7tc$aom$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: artipc9.vub.ac.be
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
	git://git.gnome.org/pan2)
Cc: linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a HP EliteBook 8470p on which I installed Debian Wheezy in UEFI 
mode. With both the 3.2 kernel from Wheezy, as the 3.7.1 kernel from 
experimental, xhci fails to initialize and my USB mouse connected to one 
of these ports is not recognized at all. The USB3 ports work fine in 
Windows.

[    1.316248] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    1.316251] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    1.316253] 
[    1.316277] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.316281] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.316287] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 1
[    1.316393] xhci_hcd 0000:00:14.0: cache line size of 64 is not 
supported
[    1.316395] xhci_hcd 0000:00:14.0: request interrupt 255 failed
[    1.316447] xhci_hcd 0000:00:14.0: USB bus 1 deregistered
[    1.316466] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    1.316467] xhci_hcd 0000:00:14.0: init 0000:00:14.0 fail, -22
[    1.316505] xhci_hcd: probe of 0000:00:14.0 failed with error -22

Full dmesg, lspci, lsusb and lsmod can be found here:
http://artipc10.vub.ac.be/~frederik/uefi-xhci/

I found this report about the same problem on a HP Probook system: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072918 

-- 
Frederik Himpe

