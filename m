Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab2DZV2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:28:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46762 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <1335379853-10122-1-git-send-email-lars@metafoo.de>
References: <1335379853-10122-1-git-send-email-lars@metafoo.de>
Date: Thu, 26 Apr 2012 23:28:42 +0200
Message-ID: <CACRpkdaZv0ufh1fh9kmeXu0cC9GFWNwyVT6bXJSSWsM3bGSqog@mail.gmail.com>
Subject: Re: [PATCH 1/3] dmaengine: Use sg_dma_address instead of sg_phys
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Yong Wang <yong.y.wang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 8:50 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:

> dmaengine drivers should always use sg_dma_address instead of sg_phys to get the
> addresses for the transfer from a sg element.

All three patches look correct to me (cannot test right now though).
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
