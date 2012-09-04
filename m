Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2IDBMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 21:12:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51401 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2IDBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 21:12:20 -0400
Date: Tue, 4 Sep 2012 09:12:17 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 0/4] Add device tree support for on-chip SRAM
Message-ID: <20120904011215.GJ2362@S2101-09.ap.freescale.net>
References: <1346688128-22395-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346688128-22395-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 06:02:04PM +0200, Philipp Zabel wrote:
> Changes since v2, as per Shawn's suggestions:
>  - Moved struct device_node declaration out of #ifdef CONFIG_OF.
>  - Simplified of_get_named_gen_pool using of_parse_phandle and
>    of_address_to_resource.
>  - Return -EADDRNOTAVAIL if devm_request_and_ioremap fails.
>  - Squashed i.MX changes together.
> 
For the series:

Reviewed-by: Shawn Guo <shawn.guo@linaro.org>

Though it will be very simple one, we may still need a binding doc for
that "sram" driver.

Regards,
Shawn
