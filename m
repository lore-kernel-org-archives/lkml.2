Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0EVK03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:26:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60818 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0EVK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:26:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BF7B147.9020502@s5r6.in-berlin.de>
Date: Sat, 22 May 2010 12:26:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: DMAR:[fault reason 02] Present bit in context entry is clear (firewire-ohci)
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I came across a report of the subject message.  What does it mean; what
type of bug should be look for?

https://bugzilla.redhat.com/show_bug.cgi?id=587178
>>>
firewire_ohci 0000:04:00.4: PCI INT C -> GSI 16 (level, low) -> IRQ 16
firewire_ohci 0000:04:00.4: setting latency timer to 64
firewire_ohci: Added fw-ohci device 0000:04:00.4, OHCI version 1.0
DRHD: handling fault status reg 2
DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
DMAR:[fault reason 02] Present bit in context entry is clear
DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
DMAR:[fault reason 02] Present bit in context entry is clear
DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
DMAR:[fault reason 02] Present bit in context entry is clear
<<<

The log sounds as if this happens during from-device DMA of 04:00.4 into
a consistent buffer, yet the fault is logged for device 04:00.0.  The
log is from a Dell M4500.  The devices are, according to a web search,
04:00.0 CardBus bridge [0607]: Ricoh Co Ltd Device [1180:e476] (rev 02)
04:00.4 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd Device [1180:e832]
(rev 03) (prog-if 10)

Thanks for any hint,
-- 
Stefan Richter
-=====-==-=- -=-= =-==-
http://arcgraph.de/sr/
