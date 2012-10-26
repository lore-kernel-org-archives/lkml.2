Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2JZI70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:59:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:39401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2JZI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:59:23 -0400
Subject: Re: [PATCH v2 3/4] DMA: PL330: Balance module remove function with
 probe
From: Vinod Koul <vkoul@infradead.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
In-Reply-To: <CAG17yqQBep4Y3YOGVFr6s_apX9f0YeTC7dxDcTQM7ahxnr1B4w@mail.gmail.com>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	 <1349432276-22919-4-git-send-email-inderpal.singh@linaro.org>
	 <1351052091.5263.19.camel@vkoul-udesk3>
	 <CAG17yqQBep4Y3YOGVFr6s_apX9f0YeTC7dxDcTQM7ahxnr1B4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Oct 2012 10:15:23 +0530
Message-ID: <1351226723.7077.14.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 16:53 +0530, Inderpal Singh wrote:
> 
> This code will get executed only in case of force removal of the
> module which was discussed in the first version of the patch at [1].
> Now, if we do not have to think about force removal then this patch
> will go back to the first version.
But why are you doing force removal of driver even when client is
holding a reference to you.

What happens when client finally tries to free the channel?

What is the problem you are trying to solve?
> 
> Let me know your view.
> 
> [1] https://patchwork.kernel.org/patch/1503171/
> 


-- 
Vinod Koul
Intel Corp.

