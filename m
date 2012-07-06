Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2GFOIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:08:32 -0400
Received: from 8bytes.org ([85.214.48.195]:38163 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2GFOIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:08:31 -0400
Date: Fri, 6 Jul 2012 16:08:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/28] AMD IOMMU interrupt remapping support
Message-ID: <20120706140827.GA2412@8bytes.org>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  6 16:08:28 2012
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4ff6f15c20421429611999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:36:20PM +0200, Joerg Roedel wrote:
> Hi,
> 
> this patch-set adds support for IRQ remapping to the AMD IOMMU driver in
> Linux. It works similar to the already present IRQ remapping code for
> VT-d. The IOAPIC, HPET and MSI interrupts have a fixed setup to index an
> interrupt remapping table entry and the real vector and destination is
> only configured in the IRQ remapping table. This means that also the IRQ
> affinity is only changed in the IOMMU. The code was heavily
> stress-tested on a lot of machines and no known issues are left.
> 
> I also pushed this code into a branch of the IOMMU tree:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git irq-remapping

Okay, I updated this branch (non-fast-forward) with my current state. It
includes the fixes for Joe's objection and for all problems reported by
Fengguang Wu. While at it I added a patch to fix most of the other
sparse warnings in the AMD IOMMU driver. Thanks again for the reports
guys :)

I will wait for more comments and fixes to come up (including the
rewrite of patch 3 as requested by Ingo) and repost the patch-set some
time next week.

Thanks so far,

       Joerg


