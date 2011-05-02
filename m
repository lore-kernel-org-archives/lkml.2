Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1EBGgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:36:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:54688 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab1EBGgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:36:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,301,1301900400"; 
   d="scan'208";a="686872142"
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
From: "Koul, Vinod" <vinod.koul@intel.com>
To: =?UTF-8?Q?=E5=BA=B7=E5=89=91=E6=96=8C?= <kjbmail@gmail.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com
In-Reply-To: <4DBA8F30.2060206@gmail.com>
References: <4DBA8F30.2060206@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 11:34:20 +0530
Message-ID: <1304316260.1589.2.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 18:13 +0800, 康剑斌 wrote:
> I try to use ioatdam to copy data from system memory to pci MMIO space:

> If dst points to a memory space, the operation would pass.
> But if dst points to a pci MMIO space, it failed with kernel oops.
> It seems the code:
> BUG_ON(is_ioat_bug(chanerr));
> in drivers/dma/ioat/dma_v3.c, line 365 cause the oops.
> Is there anyway to access pci MMIO space using ioat?
> The datasheet says that ioat supports MMIO access.
Did you map the IO memory in kernel using ioremap and friends first?

-- 
~Vinod

