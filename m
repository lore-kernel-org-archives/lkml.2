Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1GHPAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:00:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1GHPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:00:33 -0400
Date: Fri, 8 Jul 2011 07:57:25 -0700
From: Greg KH <gregkh@suse.de>
To: adharmap@codeaurora.org
Cc: davidb@codeaurora.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Joe Perches <joe@perches.com>, Daniel Walker <dwalker@fifo99.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Qualcomm PM8921 MFD 4/6] mfd: pm8xxx-mpp: Add pm8xxx MPP driver
Message-ID: <20110708145725.GA2395@suse.de>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
 <1299104001-5240-5-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299104001-5240-5-git-send-email-adharmap@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 02:13:19PM -0800, adharmap@codeaurora.org wrote:
> From: David Collins <collinsd@codeaurora.org>
> 
> Add support for multi-purpose pins (MPPs) on Qualcomm PM8xxx
> PMIC chips.
> 
> PM8xxx MPPs can be configured as digital or analog inputs or
> outputs, current sinks, or buffers.
> 
> Change-Id: Iab39b2f7c2ba3f35ef6ac74d37ee7add8c70681f

What is this line for?  It makes no sense for a patch that is being
submitted to the kernel tree, please remove it.

> Signed-off-by: David Collins <collinsd@codeaurora.org>

Why have you sent this patch from a different email address than this
one?

greg k-h
