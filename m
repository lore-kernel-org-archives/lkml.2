Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2DMW14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:27:56 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58682 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab2DMW1z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:27:55 -0400
MIME-Version: 1.0
In-Reply-To: <4F8672CC.2040500@st.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-3-git-send-email-mturquette@linaro.org> <4F8672CC.2040500@st.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 13 Apr 2012 15:27:32 -0700
Message-ID: <CAJOA=zPfYTj=o1HKiBaL5J+aa4BsTFPFDYZ5FcBkNzRd7jTZXA@mail.gmail.com>
Subject: Re: [PATCH 02/13] clk: core: remove dead code paths
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 11:14 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 4/12/2012 6:32 AM, Mike Turquette wrote:
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 3ed36d3..4daacf5 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -194,7 +194,7 @@ static int __init clk_debug_init(void)
>>  late_initcall(clk_debug_init);
>>  #else
>>  static inline int clk_debug_register(struct clk *clk) { return 0; }
>> -#endif /* CONFIG_COMMON_CLK_DEBUG */
>> +#endif
>
> Why is this updated? Isn't this considered good practice anymore?

See comments in this thread:
http://article.gmane.org/gmane.linux.kernel/1276102

Regards,
Mike
