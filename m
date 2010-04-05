Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0DERiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 13:38:06 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:54056 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab0DERh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 13:37:59 -0400
X-Greylist: delayed 1472 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2010 13:37:59 EDT
Date: Mon, 5 Apr 2010 19:13:18 +0200
To: Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002) on DEC
 Alpha Personal Workstation 433au
Message-ID: <20100405171318.GA18915@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
X-Originating-IP: 160.45.64.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I installed Debian unstable on an old digital workstation "DEC Digital
Personal Workstation 433au" (Miata) which has an on-board tulip
network controller. I'm not really using that network controller but
an off-board intel e1000 controller. However, I found that the tulip
driver produces a lot of noise in the message log, the following
message is repated periodically and spams the whole message log:

0000:00:03.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)

Do you think this is related to the fact that no cable is connected to
the network controller?

The lspci output of the hardware looks like this:

test-adrian1:~# lspci
00:03.0 Ethernet controller: Digital Equipment Corporation DECchip 21142/43 (rev 30)
00:07.0 ISA bridge: Contaq Microsystems 82c693
00:07.1 IDE interface: Contaq Microsystems 82c693
00:07.2 IDE interface: Contaq Microsystems 82c693
00:07.3 USB Controller: Contaq Microsystems 82c693
00:0b.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2064W [Millennium] (rev 01)
00:14.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03)
01:04.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
01:09.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller

If you need anymore verbose or debug output, please let me know.

Adrian
