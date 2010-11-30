Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0K3UcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:32:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:35041 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab0K3UcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:32:07 -0500
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mitch Bradley <wmb@firmworks.com>, Scott Wood <scottwood@freescale.com>,
        sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4CF4E54D.5040403@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	 <1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>
	 <1290984809.32570.208.camel@pasglop>
	 <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
	 <1291061128.32570.298.camel@pasglop> <4CF40DF4.9060204@firmworks.com>
	 <4CF4E54D.5040403@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 07:31:40 +1100
Message-ID: <1291149100.32570.393.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 12:51 +0100, Sebastian Andrzej Siewior wrote:
> My PCI node does not have a reg property but its child nodes.
> In x86_of_pci_init() [0] I walk through the PCI child nodes, read the reg
> property of each node  which gives me the devfn of the device. I pass this
> pci_get_slot() and get the pci_dev struct where I attach the of_node. So
> it can by used by the pci driver.
> 
> How do I create the PCI device <-> OF node mapping with this? I think your
> isa node has this as well. 00008800 is the devfn and I simply forgot the
> four blocks of zeros.

I think Mitch meant the PCI host bridge usually has a reg property in
the address space of the parent, used to identify the bridge uniquely if
you have multiple of them.

Cheers,
Ben.


