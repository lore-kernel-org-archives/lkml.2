Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1CHXbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:31:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60485 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756170Ab1CHXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:31:04 -0500
Date: Tue, 8 Mar 2011 23:31:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: adharmap@codeaurora.org
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 5/6] MAINTAINERS: Add patterns for
 pmic 8921 files to MSM subsystem
Message-ID: <20110308233122.GC2717@opensource.wolfsonmicro.com>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org>
 <1299564590-30116-6-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299564590-30116-6-git-send-email-adharmap@codeaurora.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 10:09:49PM -0800, adharmap@codeaurora.org wrote:

> +F:	include/linux/mfd/pm8???.h
> +F:	include/linux/mfd/pm8xxx/

Shouldn't the pm8???.h files be in the directory?
