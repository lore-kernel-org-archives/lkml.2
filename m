Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1DGHaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:30:16 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:44347 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab1DGHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:30:14 -0400
Message-ID: <4D9D67F5.8030703@stericsson.com>
Date: Thu, 7 Apr 2011 09:29:57 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv5 1/3] ARM: Translate delay.S into (mostly) C
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org> <1302047800-26720-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1302047800-26720-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 01:56 AM, Stephen Boyd wrote:
> We want to allow machines to override the __delay() implementation
> at runtime so they can use a timer based __delay() routine. It's
> easier to do this using C, so let's write udelay and friends in C.
>
> We lose the #if 0 code, which according to Russell is used "to
> make the delay loop more stable and predictable on older CPUs"
> (seehttp://article.gmane.org/gmane.linux.kernel/888867  for more
> info). We shouldn't be too worried though, since we'll soon add
> functionality allowing a machine to set the __delay() loop
> themselves, thus allowing machines to resurrect the commented out
> code should they need it.
>
> Nicolas expressed concern that fixed lpj cmdlines will break due to
> compiler optimizations. That doesn't seem to be the case since
> before and after this patch I get the same lpj value when running
> my CPU at 19.2 MHz. That should be sufficiently slow enough to
> cover any machine running Linux.

Tested-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin

