Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1HWOnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:43:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1HWOnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:43:14 -0400
Subject: Re: [PATCH] DMAEngine: Define generic transfer request api
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Matt Porter <mporter@ti.com>
In-Reply-To: <1313761404.18591.1.camel@vkoul-udesk3>
Date: Tue, 23 Aug 2011 10:43:05 -0400
CC: Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>, <sundaram@ti.com>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <rmk+kernel@arm.linux.org.uk>,
        <nsekhar@ti.com>
Content-Transfer-Encoding: 7bit
Message-ID: <DD211C52-97D7-4E55-A2F8-3C88A6D45A75@ti.com>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>  <1313499399.1603.92.camel@vkoul-udesk3>  <CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com> <1313761404.18591.1.camel@vkoul-udesk3>
To: "Koul, Vinod" <vinod.koul@intel.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 19, 2011, at 9:43 AM, Koul, Vinod wrote:

> On Tue, 2011-08-16 at 15:06 +0200, Linus Walleij wrote:
>> On Tue, Aug 16, 2011 at 2:56 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
>> 
>>> Currently we have two approaches to solve this problem first being the
>>> DMA_STRIDE_CONFIG proposed by Linus W, I feel this one is better
>>> approach as this can give client ability to configure each transfer
>>> rather than set for the channel. Linus W, do you agree?
>> 
>> I think Sundaram is in the position of doing some heavy work on
>> using one or the other of the API:s, and I think he is better
>> suited than anyone else of us to select what scheme to use,
>> in the end he's going to write the first code using the API.
> And Unfortunately TI folks don't seem to care about this discussion :(
> Haven't seen anything on this from them, or on previous RFC by Jassi

IIRC, Sundaram went on holiday. I suspect he cares a lot about this
discussion as he has a session on the topic at LPC.

-Matt
