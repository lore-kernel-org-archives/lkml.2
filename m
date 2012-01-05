Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2AEDe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:34:59 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58056 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525Ab2AEDe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:34:56 -0500
Message-ID: <4F051A47.3020401@st.com>
Date: Thu, 5 Jan 2012 09:04:31 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: pl061: remove combined interrupt
References: <1325705506-24230-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1325705506-24230-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/2012 1:01 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Drivers should not have a dependency on NR_IRQS. Doing so may break with
> SPARSE_IRQ enabled. As there are no in kernel users of the pl061 which
> have multiple instances with their interrupts combined to a single parent
> interrupt, remove this functionality. If this capability is needed later,
> it could be supported more cleanly by just using a devicetree property.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/gpio/gpio-pl061.c |   44 ++++++++------------------------------------
>  1 files changed, 8 insertions(+), 36 deletions(-)

Looks fine.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
