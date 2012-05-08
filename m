Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2EHJPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:15:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47021 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2EHJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:15:32 -0400
Date: Tue, 8 May 2012 11:15:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: joro@8bytes.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 3/3] irq_remap: fix the 'sub_handle' uninitialized warning
Message-ID: <20120508091526.GD27323@gmail.com>
References: <20120508035153.GA30652@gmail.com>
 <1336460934-23592-3-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336460934-23592-3-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another problem is that drivers/iommu/intel_irq_remapping.c is 
supplied with comments rather poorly - I have to page down 
almost 300 lines to see the first substantial comment! Copyright 
notices would be nice as well.

So lets do a better job and document this thing a bit better. 
Please also align structure definitions vertically, like we 
typically to do in new code.

The file names should probably also be standardized (but that 
should come via a Git space pull request, using git mv and 
such). What we have currently is pretty random: 'dmar.c' should 
probably be dma_remap.c, and *irq_remapping.c should probably be 
*irq_remap.c.

Thanks,

	Ingo
