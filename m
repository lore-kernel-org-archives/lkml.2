Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3AJIez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:34:55 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:50282 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3AJIex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:34:53 -0500
Date: Thu, 10 Jan 2013 09:34:47 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/14] Rewrite Tegra PCIe driver
Message-ID: <20130110093447.646ed07c@skate>
In-Reply-To: <20130110065537.GC15212@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
	<20130109222517.3c590553@skate>
	<20130110065537.GC15212@avionic-0098.adnet.avionic-design.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thierry Reding,

On Thu, 10 Jan 2013 07:55:37 +0100, Thierry Reding wrote:

> The reason is that with the latest bindings the matching of root ports
> to device tree nodes works as-is and nothing else indicates that the
> emulated host bridge is actually required to make any of this work. So
> in order not to introduce unneeded code I've left it out for now. If
> somebody decides that we actually need this host bridge (for standards
> compliance or whatnot) it could easily be added back.

Ok.

> However, before the emulated bridge implementation can be merged I think
> the PCI ID issue needs to be resolved.

Indeed. I am not sure yet how to solve that, though.

> > So, I instantiate one unique emulated Host Bridge, and then one
> > emulated PCI-to-PCI Bridge for each PCIe interface that I have.
> 
> Oh dear, that's even worse than on Tegra. The Marvell hardware doesn't
> even expose the root ports as PCI devices on the bus?

My understanding is that no, it doesn't, but I am still figuring out
many things in this PCIe topic.

> I suppose that in your case it really makes sense because you already
> need the emulated PCI-to-PCI bridges and therefore adding an emulated
> host bridge doesn't add much. As I said, for Tegra everything still
> works without, so I didn't see a reason to add needless code.

Ok, thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
