Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2FLF2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:28:13 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:53528 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab2FLF2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:28:12 -0400
Message-ID: <4FD6D361.2020305@ti.com>
Date: Tue, 12 Jun 2012 10:58:01 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH RESEND v4] input: keyboard: Add keys driver for the LPC32xx
 SoC
References: <1339443891-15197-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339443891-15197-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2012 01:14 AM, Roland Stigge wrote:
> +
> +struct lpc32xx_kscan_drv {
> +	struct input_dev *input;
> +	struct lpc32xx_kscan_cfg *kscancfg;
> +	struct clk *clk;
> +	void __iomem *kscan_base;
> +	int irq;
Do you really need this irq field?  It is used in the probe and remove only.

> +	u8 lastkeystates[8];
> +	u32 io_p_start;
> +	u32 io_p_size;
> +};

