Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1KKLkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:40:20 -0500
Received: from gimli.pitney-fabs.co.uk ([87.106.140.52]:38625 "EHLO
	gimli.pitney-fabs.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1KKLkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:40:19 -0500
Date: Fri, 11 Nov 2011 11:40:15 +0000
From: Andrew Walrond <andrew@walrond.org>
To: linux-kernel@vger.kernel.org
Subject: Re: eth0/1 swapped places after kernel Upgrade 3.0.8 -> 3.1.0 (and
 udev 172 -> 174)
Message-ID: <20111111114014.GA1962@andrews-imac.pitney-fabs>
References: <20111102101404.GA5195@andrew-xps.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102101404.GA5195@andrew-xps.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 10:14:04AM +0000, Andrew Walrond wrote:
> Not sure if this is a udev or kernel issue, or indeed whether I
>  should expect these devices to have persistent naming at all
>  without some udev configuration of my own, but I thought I'd
>  report it just in case it's useful.
> 
> Output from lspci:
> 
> 03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> 07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> 

It's worse than I thought; eth0/eth1 are randomly swapping places on boot.
Is this likely to be a kernel or udev problem?

Relevant kernel messages:

bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.11 (July 20, 2011)
bnx2 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
bnx2 0000:03:00.0: eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node addr 00:1d:09:64:ae:03
bnx2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
bnx2 0000:07:00.0: eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f4000000, IRQ 16, node addr 00:1d:09:64:ae:05
bnx2 0000:03:00.0: irq 47 for MSI/MSI-X
bnx2 0000:03:00.0: eth0: using MSI
bnx2 0000:03:00.0: eth0: NIC Copper Link is Up, 100 Mbps full duplex, receive & transmit flow control ON
bnx2 0000:07:00.0: irq 48 for MSI/MSI-X
bnx2 0000:07:00.0: eth1: using MSI
bnx2 0000:07:00.0: eth1: NIC Copper Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON


Please let me know if I need to redirect this elsewhere.

> Andrew Walrond
> 
