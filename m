Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab2JZJGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:06:05 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34285 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2JZJF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:05:58 -0400
MIME-Version: 1.0
In-Reply-To: <1351241315.7077.16.camel@vkoul-udesk3>
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org>
	<169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org>
	<CAKohpokEXAGD-nUF6u8tugvF2ffJx3HLLd+Zgc2+6GB9hxnT6Q@mail.gmail.com>
	<1351241315.7077.16.camel@vkoul-udesk3>
Date: Fri, 26 Oct 2012 14:35:57 +0530
Message-ID: <CAKohpo=4QDBuFZJrdCkXzijx4aD0rNXf1X2wS9LG17zg_LeAYg@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 October 2012 14:18, Vinod Koul <vkoul@infradead.org> wrote:
> On Fri, 2012-10-26 at 14:25 +0530, Viresh Kumar wrote:
>> I can see that you applied these patches and they are present in
>> linux-next. But i feel
>> the order of patches is bad.
> Yes looks like I forgot to sort the mbox series :(
>
> since all patches were applied nicely, and they seem fairly independent
> of each other it should cause issue. Let me know if you wnat me to redo
> my -next.

yes. The ARCH specific patch 3/3 uses a routine created in 2/3. So they have
to be in right order for git bisect to work.

--
viresh
