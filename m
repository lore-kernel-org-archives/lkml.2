Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1HSNnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:43:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:17543 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab1HSNnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,251,1312182000"; 
   d="scan'208";a="8934767"
Subject: Re: [PATCH] DMAEngine: Define generic transfer request api
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, sundaram@ti.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        nsekhar@ti.com
In-Reply-To: <CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	 <1313499399.1603.92.camel@vkoul-udesk3>
	 <CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 19:13:24 +0530
Message-ID: <1313761404.18591.1.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 15:06 +0200, Linus Walleij wrote:
> On Tue, Aug 16, 2011 at 2:56 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> 
> > Currently we have two approaches to solve this problem first being the
> > DMA_STRIDE_CONFIG proposed by Linus W, I feel this one is better
> > approach as this can give client ability to configure each transfer
> > rather than set for the channel. Linus W, do you agree?
> 
> I think Sundaram is in the position of doing some heavy work on
> using one or the other of the API:s, and I think he is better
> suited than anyone else of us to select what scheme to use,
> in the end he's going to write the first code using the API.
And Unfortunately TI folks don't seem to care about this discussion :(
Haven't seen anything on this from them, or on previous RFC by Jassi

-- 
~Vinod

