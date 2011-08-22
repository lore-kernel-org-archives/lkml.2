Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1HVNa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:30:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:36451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1HVNaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:30:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,263,1312182000"; 
   d="scan'208";a="42702664"
Date: Mon, 22 Aug 2011 15:32:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Balaji T K <balajitk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] mfd: twl6030-irq: Make sure to call request_irq before
 using the irq_num
Message-ID: <20110822133254.GP4607@sortiz-mobl>
References: <1313047260.27089.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313047260.27089.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Aug 11, 2011 at 03:21:00PM +0800, Axel Lin wrote:
> I was trying to fix the error handling part because in the case of
> request_irq failure, it should call kthread_stop instead of free_irq.
> But it seems more reasonable to do request_irq before calling kthread_run.
I don't have the hardware, but that makes sense to me.
Unless some from TI NACK this patch, I'm applying it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
