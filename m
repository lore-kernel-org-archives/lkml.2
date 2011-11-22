Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1KVPtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:49:12 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35315 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757209Ab1KVPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:49:10 -0500
X-Sasl-enc: qFCSkgGs8MiWBpEmz+ksgTCk8vJybAlciyfHZnWFr1zf 1321976949
Date: Tue, 22 Nov 2011 07:42:59 -0800
From: Greg KH <greg@kroah.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 0/5] common clk framework
Message-ID: <20111122154259.GA18954@kroah.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:40:42PM -0800, Mike Turquette wrote:
>   .sysfs support.  Visualize your clk tree at /sys/clk!  Where would be
> a better place to put the clk tree besides the root of /sys/?

Um, in the "proper" place for it under /sys/devices like the rest of the
device tree is?

> When a consensus on this is reached I'll submit the proper changes to
> Documentation/ABI/testing/.

I would like to see this documentation now, as it explains what you are
trying to do with the userspace api.

More comments on your sysfs patch...

thanks,

greg k-h
