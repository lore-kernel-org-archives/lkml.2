Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2DLGQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:16:33 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:49167 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079Ab2DLGQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:16:31 -0400
Message-ID: <4F8672CC.2040500@st.com>
Date: Thu, 12 Apr 2012 11:44:36 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH 02/13] clk: core: remove dead code paths
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 3ed36d3..4daacf5 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -194,7 +194,7 @@ static int __init clk_debug_init(void)
>  late_initcall(clk_debug_init);
>  #else
>  static inline int clk_debug_register(struct clk *clk) { return 0; }
> -#endif /* CONFIG_COMMON_CLK_DEBUG */
> +#endif

Why is this updated? Isn't this considered good practice anymore?

-- 
viresh
