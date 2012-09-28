Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab2I1QYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:24:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52546 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2I1QYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:24:47 -0400
Message-ID: <5065CF4A.9070406@wwwdotorg.org>
Date: Fri, 28 Sep 2012 10:24:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: Re: [PATCH v2] pinctrl: clarify idle vs sleep states
References: <1348816688-27531-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1348816688-27531-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 01:18 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This pure documentation fix tries to align the "idle" and
> "sleep" pin states to the idle and suspend states from
> runtime PM.
> 
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - I changed my mind slightly after experimentation in practice
>   (empirical stuff is the best). So now I think "idle" is for
>   runtime_suspend(), and "sleep" is for suspend() proper. This
>   works best in practice for us. I'm trying to set some model
>   here that will be easy to understand and usable for typical
>   cases.

Yes, I think this makes sense.

Acked-by: Stephen Warren <swarren@nvidia.com>
