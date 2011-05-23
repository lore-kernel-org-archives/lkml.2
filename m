Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1EWSmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:42:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1EWSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:42:36 -0400
Date: Mon, 23 May 2011 14:42:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver out
 of staging
Message-ID: <20110523184233.GA26835@infradead.org>
References: <1306170743-17797-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306170743-17797-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#include <linux/version.h>

This one shouldn't be needed.

> +#include <asm/hyperv.h>
> +#include <asm/mshyperv.h>

not really a review for this driver, but what's the purpose if having
these two headers?

Shouldn't the Kconfig entry also move from drivers/staging to
arch/x86 towards the other clocksources?
