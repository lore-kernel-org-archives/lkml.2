Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0GAWF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:05:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3074 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab0GAWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:05:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46223272"
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: Daniel Walker <dwalker@codeaurora.org>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Andi Kleen <andi@firstfloor.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <4C2D0FF1.6010206@codeaurora.org>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org>
	 <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org>
	 <20100701101746.3810cc3b.randy.dunlap@oracle.com>
	 <20100701180241.GA3594@basil.fritz.box>
	 <1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com>
	 <20100701193850.GB3594@basil.fritz.box>  <4C2D0FF1.6010206@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 15:05:44 -0700
Message-ID: <1278021944.7738.43.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 15:00 -0700, Zach Pfeffer wrote:


> Additionally, the current IOMMU interface does not allow users to
> associate one page table with multiple IOMMUs unless the user explicitly
> wrote a muxed device underneith the IOMMU interface. This also could be
> done, but would have to be done for every such use case. Since the
> particular topology is run-time configurable all of these use-cases and
> more can be expressed without pushing the topology into the low-level
> IOMMU driver.
> 
> The VCMM takes the long view. Its designed for a future in which the
> number of IOMMUs will go up and the ways in which these IOMMUs are
> composed will vary from system to system, and may vary at
> runtime. Already, there are ~20 different IOMMU map implementations in
> the kernel. Had the Linux kernel had the VCMM, many of those
> implementations could have leveraged the mapping and topology management
> of a VCMM, while focusing on a few key hardware specific functions (map
> this physical address, program the page table base register).

So if we include this code which "map implementations" could you
collapse into this implementations ? Generally , what currently existing
code can VCMM help to eliminate?

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

