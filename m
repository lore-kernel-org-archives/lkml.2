Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab0DAUWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:22:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab0DAUWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:22:05 -0400
Date: Thu, 1 Apr 2010 13:17:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alex Deucher <alexdeucher@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780
  (was: Re: Linux 2.6.34-rc3)
In-Reply-To: <i2ga728f9f91004011053u75097a2n3706f946dfd8f6fb@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004011313120.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>  <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>  <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>  <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com>
  <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org> <i2ga728f9f91004011053u75097a2n3706f946dfd8f6fb@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Alex Deucher wrote:
> 
> What I meant to say was MSI works fine on bridges other than the
> bridge the internal gfx lives on.  quirk_disable_msi() just disables
> MSI on the devices on that particular bridge as far as I understand
> it, but I'm by no means an expert on the PCI code.

Yes, it disabled MSI only on devices under that bridge. But if it's the 
northbridge, that would be everything, no?

But I don't know what devices those

	PCI_VENDOR_ID_AMD, 0x9602,
	PCI_VENDOR_ID_ASUSTEK, 0x9602,

things are. If they are just a PCIE->PCI bridge rather than the root 
bridge, then everything looks fine to me.

			Linus
