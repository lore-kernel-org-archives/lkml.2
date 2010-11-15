Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab0KORg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:36:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:51565 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112Ab0KORg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:36:27 -0500
Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1289477789-10651-1-git-send-email-leoli@freescale.com>
Date: Mon, 15 Nov 2010 09:17:18 -0600
Cc: <dan.j.williams@intel.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <DCEA5DA7-D0DC-498C-831D-4EF212DE6421@kernel.crashing.org>
References: <1289477789-10651-1-git-send-email-leoli@freescale.com>
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 11, 2010, at 6:16 AM, Li Yang wrote:

> Expand the dma_mask of fsldma device to 36-bit, indicating that the
> DMA engine can deal with 36-bit physical address and does not need
> the SWIOTLB to create bounce buffer for it when doing dma_map_*().
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> Add more detailed commit message
> 
> drivers/dma/fsldma.c |    4 +++-
> 1 files changed, 3 insertions(+), 1 deletions(-)

Acked-by: Kumar Gala <galak@kernel.crashing.org>

- k
