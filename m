Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1KWSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:44:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab1KWSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:44:19 -0500
Date: Wed, 23 Nov 2011 18:44:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, robherring2@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, lrg@ti.com,
        b-cousson@ti.com, patches@linaro.org, linux-kernel@vger.kernel.org,
        shawn.guo@freescale.com, linaro-dev@lists.linaro.org, olof@lixom.net
Subject: Re: [PATCH v5 4/4] regulator: map consumer regulator based on device
 tree
Message-ID: <20111123184416.GA17587@opensource.wolfsonmicro.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
 <1321615040-13257-5-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321615040-13257-5-git-send-email-rnayak@ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 04:47:20PM +0530, Rajendra Nayak wrote:

> +	struct device_node *regnode = NULL;
> +	char prop_name[32]; /* 32 is max size of property name */

There ought to be a #define for that though I can't see one right now -
this can't be the only place where we need to do stuff like this.

> +
> +	dev_dbg(dev, "Looking up %s-supply from device tree\n", supply);
> +
> +	snprintf(prop_name, 32, "%s-supply", supply);

sizeof().
