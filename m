Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab1LPIwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:52:50 -0500
Received: from 8bytes.org ([88.198.83.132]:46870 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1LPIws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:52:48 -0500
Date: Fri, 16 Dec 2011 09:52:47 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: manual merge of the iommu tree with the
	pci-current tree
Message-ID: <20111216085247.GA28302@8bytes.org>
References: <20111216133026.8bac235bb8495cfd8669b761@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216133026.8bac235bb8495cfd8669b761@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Dec 16, 2011 at 01:30:26PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the iommu tree got a conflict in
> drivers/pci/hotplug/acpiphp_glue.c between commit 619a5182d1f3 ("PCI
> hotplug: Always allow acpiphp to handle non-PCIe bridges") from the
> pci-current tree and commit d90116ea38f7 ("PCI/ACPI: Make acpiphp ignore
> root bridges using SHPC native hotplug") from the iommu tree.

That's weird. This conflict is between a patch in my tree which I pulled
in from the PCI tree and another patch from the PCI tree. So any
conflict should already be solved in the PCI tree, no?

Jesse, the pri-changes branch you provided me is a subset of your
linux-next branch, right?

> I fixed it up (I think - see below) and can carry the fix as necessary.

Jesse should comment on the correctness of the fix :)


	Joerg

