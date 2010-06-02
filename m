Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab0FBTUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:20:24 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34449 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab0FBTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:20:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Bert dd <bert.ddecker@gmail.com>
Subject: Re: Is there a way to change irq numbers of pcie cards ?
Date: Wed, 2 Jun 2010 13:19:59 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <AANLkTinfWMJ94pPxjRAx-vgvcqSwE9Hw3kHqEDLazhZ2@mail.gmail.com>
In-Reply-To: <AANLkTinfWMJ94pPxjRAx-vgvcqSwE9Hw3kHqEDLazhZ2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021319.59402.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I added linux-pci, where more PCI-savvy people will see it.]

On Wednesday, June 02, 2010 06:08:33 am Bert dd wrote:
> Hi,
> Is there a way to change irq numbers of pcie cards ?
> 
> I have a supermicro machine with 2 raid cards (lsi 9260-8i and lsi 9260-8e) and
> one nvidia GTX480 graphics card.
> The problem is that all these pcie cards are assigned the same irq number,
> and thus all the interrupts are routed to the same cpu which can not
> handle this.
> If I replace the nvidia GTX480 with an older graphics card(too old for
> our purposes (GTX295)), the graphics card gets a different irq number
> than the raid cards, the interrups of the graphics card are handled by
> a different cpu than those of the raid cards, and the read/write speed
> of the raid increases.
> I am reading/writing at 2.5 GB/s to the raid and I am uploading
> textures at 0.5 GB/s to the graphics hardware.
> Is there a way to change the irq numbers of the pcie cards ?
> I am using IOAPIC for interrupt routing.

I would think performance-oriented PCIe devices would be using
some sort of MSI, but I'm not really an expert in that area.

Can you post your /proc/interrupts and complete dmesg log in
case nobody jumps in with an obvious answer?

Bjorn

> I am using ubuntu - kernel version 2.6.31-14-generic.
> 
> thanks,
>   Bert De Decker
>   bert.dedecker@uhasselt.be
