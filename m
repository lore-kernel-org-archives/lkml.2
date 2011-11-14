Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1KMX5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:57:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:47645 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1KMX5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:57:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,503,1315206000"; 
   d="scan'208";a="36652504"
Date: Mon, 14 Nov 2011 01:01:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] mfd: Add missed free_irq in da903x_remove
Message-ID: <20111114000157.GB22218@sortiz-mobl>
References: <1320028441.2690.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320028441.2690.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Oct 31, 2011 at 10:34:01AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/da903x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
Thanks, I applied this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
