Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1ESQwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:52:43 -0400
Received: from ns5.dns-guards.com ([41.203.20.164]:30521 "EHLO
	velocity.dns-guards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab1ESQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:52:42 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 12:52:41 EDT
Message-ID: <sig.9120f46b2d.4DD5452F.9050108@radicalsystems.co.za>
Date: Thu, 19 May 2011 18:28:31 +0200
From: Jan Zwiegers <jan@radicalsystems.co.za>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: PCI BAR1 Unassigned
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-ID: velocity.dns-guards.com ()
X-Assp-Version: 1.7.1.3(1.0.2)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - velocity.dns-guards.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - radicalsystems.co.za
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the problem below where my PCI card's second BAR does not get 
assigned.
What can be the cause of this problem?
The last kernel I tested on which worked OK was 2.6.27.
My current problematic kernel 2.6.35.

05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O 
Card (rev 5c)
     Flags: bus master, slow devsel, latency 32, IRQ 22
     Memory at 93b00000 (type 3, prefetchable) [size=2K]
     Memory at <unassigned> (type 3, prefetchable)
     Capabilities: [80] #00 [0600]
     Kernel modules: pci703drv

Cheers
Jan
