Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab2JLJaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:30:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61410 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2JLJaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Ve9uETO0Wx=bNbPxjOxO_MoE_bkFCHtwBZAA6+7m8fdMw@mail.gmail.com>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350030203.10584.139.camel@smile>
	<CAKohpon4FZdPXFOXvVqExY=xrwozELYvNbE3_zHoRw2O0nszhw@mail.gmail.com>
	<CAHp75Ve9uETO0Wx=bNbPxjOxO_MoE_bkFCHtwBZAA6+7m8fdMw@mail.gmail.com>
Date: Fri, 12 Oct 2012 15:00:23 +0530
Message-ID: <CAKohpokcW=zGP-OYQm-ZLhHJFRdnZZGyWZEbVWnj2rjqfb+j2A@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 14:55, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> I understand your way of allocating memory, but what about using
> linked list instead of array?

I gave it a thought. Overhead was 4 bytes more per slave structure +
more cycles in filter routine (arrays are more faster :) ).

Because the DT capture is a one time activity, its better to save time
in filter fns.

> And one more thing. May be we could introduce backlink to the platform
> data in the dw_dma structure instead of copying certain parameters?

Will do that in a separate patch, outside the scope of this patchset. :)

--
viresh
