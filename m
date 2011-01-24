Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1AXKRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:17:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45146 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1AXKRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:17:10 -0500
Date: Mon, 24 Jan 2011 10:17:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] ARM: pxa: fix suspend on PXA3XX
Message-ID: <20110124101701.GE16202@n2100.arm.linux.org.uk>
References: <20110124095138.GC16202@n2100.arm.linux.org.uk> <1295864152-773-1-git-send-email-s.neumann@raumfeld.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295864152-773-1-git-send-email-s.neumann@raumfeld.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:15:52AM +0100, Sven Neumann wrote:
>  static struct pxa_cpu_pm_fns pxa3xx_cpu_pm_fns = {
> +        .save           = pxa3xx_cpu_pm_save,
> +        .restore        = pxa3xx_cpu_pm_restore,

Indentation error.

>  	.valid		= pxa3xx_cpu_pm_valid,
>  	.enter		= pxa3xx_cpu_pm_enter,
>  };
k
