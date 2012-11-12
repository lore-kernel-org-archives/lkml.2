Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2KLVPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:15:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KLVP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:15:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: viresh kumar <viresh.kumar@linaro.org>, Axel Lin <axel.lin@ingics.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAOh2x==ng3A66P=Vx+-C791LTGCS1fWVpMfUKDorU5G=ZXrjLQ@mail.gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1352169260.2625.4.camel@phoenix>
 <CAOh2x==ng3A66P=Vx+-C791LTGCS1fWVpMfUKDorU5G=ZXrjLQ@mail.gmail.com>
Message-ID: <20121112211506.20034.67807@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] clk: spear: Add stub functions for spear3[0|1|2]0_clk_init()
Date: Mon, 12 Nov 2012 13:15:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting viresh kumar (2012-11-05 19:36:18)
> On Tue, Nov 6, 2012 at 8:04 AM, Axel Lin <axel.lin@ingics.com> wrote:
> > This fixes compile error if one of SPEAr3xx implementations is not selected.
> >
> >   CC      drivers/clk/spear/spear3xx_clock.o
> > drivers/clk/spear/spear3xx_clock.c: In function 'spear3xx_clk_init':
> > drivers/clk/spear/spear3xx_clock.c:599:3: error: implicit declaration of function 'spear300_clk_init' [-Werror=implicit-function-declaration]
> > drivers/clk/spear/spear3xx_clock.c:601:3: error: implicit declaration of function 'spear310_clk_init' [-Werror=implicit-function-declaration]
> > drivers/clk/spear/spear3xx_clock.c:603:3: error: implicit declaration of function 'spear320_clk_init' [-Werror=implicit-function-declaration]
> > cc1: some warnings being treated as errors
> > make[3]: *** [drivers/clk/spear/spear3xx_clock.o] Error 1
> > make[2]: *** [drivers/clk/spear] Error 2
> > make[1]: *** [drivers/clk] Error 2
> > make: *** [drivers] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Thanks..
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Taken into clk-next.

Thanks,
Mike
