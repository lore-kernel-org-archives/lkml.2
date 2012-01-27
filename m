Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2A0ESX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:18:23 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59756 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759Ab2A0ESW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:18:22 -0500
Message-ID: <4F222582.9070800@st.com>
Date: Fri, 27 Jan 2012 09:48:10 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christopher BLAIR <chris.blair@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2 v3] mfd/stmpe: Add support for no-interrupt config
References: <1327612623-9135-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1327612623-9135-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/2012 2:47 AM, Linus WALLEIJ wrote:
> +	if (stmpe->irq < 0) {
> +		/* use alternate variant info for no-irq mode, if supported */
> +		dev_info(stmpe->dev,
> +			"%s configured in no-irq mode by platform data\n",
> +			stmpe->variant->name);
> +		if (!stmpe_noirq_variant_info[stmpe->partnum]) {
> +			dev_err(stmpe->dev,
> +				"%s does not support no-irq mode!\n",
> +				stmpe->variant->name);
> +			ret = -ENODEV;
> +			goto free_gpio;
> +		}
> +		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
> +	}
> +

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
