Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1ISNiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:38:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:55859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1ISNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:38:05 -0400
Date: Mon, 19 Sep 2011 15:38:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Kuo <rkuo@codeaurora.org>
cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 18/36] Hexagon: Add time and timer functions
In-Reply-To: <e97c6e$3hno05@wolverine02.qualcomm.com>
Message-ID: <alpine.LFD.2.02.1109191536330.2723@ionos>
References: <e97c6e$3hno05@wolverine02.qualcomm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Richard Kuo wrote:
> +
> +void debug_adsp_timers(void)
> +{
> +	printk(KERN_INFO "rtos_timer->match=0x%08x\n", rtos_timer->match);
> +	printk(KERN_INFO "rtos_timer->count=%d\n", rtos_timer->count);
> +	printk(KERN_INFO "rtos_timer->enable=%d\n", rtos_timer->enable);
> +	printk(KERN_INFO "rtos_timer->clear=%d\n", rtos_timer->clear);
> +}

Does this have a caller and is it useful ?

Otherwise this looks good.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
