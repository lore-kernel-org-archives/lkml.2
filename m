Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1LPPSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:18:52 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42941 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756324Ab1LPPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:18:44 -0500
Date: Fri, 16 Dec 2011 07:18:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the iommu tree with the pci-current
 tree
Message-ID: <20111216071840.6e06864f@jbarnes-vaio.home>
In-Reply-To: <20111216085247.GA28302@8bytes.org>
References: <20111216133026.8bac235bb8495cfd8669b761@canb.auug.org.au>
	<20111216085247.GA28302@8bytes.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.73 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 09:52:47 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> Hi Stephen,
> 
> On Fri, Dec 16, 2011 at 01:30:26PM +1100, Stephen Rothwell wrote:
> > Today's linux-next merge of the iommu tree got a conflict in
> > drivers/pci/hotplug/acpiphp_glue.c between commit 619a5182d1f3 ("PCI
> > hotplug: Always allow acpiphp to handle non-PCIe bridges") from the
> > pci-current tree and commit d90116ea38f7 ("PCI/ACPI: Make acpiphp ignore
> > root bridges using SHPC native hotplug") from the iommu tree.
> 
> That's weird. This conflict is between a patch in my tree which I pulled
> in from the PCI tree and another patch from the PCI tree. So any
> conflict should already be solved in the PCI tree, no?
> 
> Jesse, the pri-changes branch you provided me is a subset of your
> linux-next branch, right?
> 
> > I fixed it up (I think - see below) and can carry the fix as necessary.
> 
> Jesse should comment on the correctness of the fix :)

Yeah, this is probably my fault; pri-changes has drifted relative to my
linux-next branch.  I'll rebase it onto linux-next and push again.
That should fix things.

Jesse
