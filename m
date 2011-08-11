Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HKRFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:05:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43322 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1HKRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:05:18 -0400
Date: Thu, 11 Aug 2011 18:04:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 02/41] arm: Use set_current_blocked()
Message-ID: <20110811170450.GB14105@e102144-lin.cambridge.arm.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
 <1313071035-12047-3-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-3-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, Aug 11, 2011 at 02:56:36PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check for shared signals we're about to block.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: Dave Martin <dave.martin@linaro.org>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> CC: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
> ---
>  arch/arm/kernel/signal.c |   25 +++++++++++--------------
>  1 files changed, 11 insertions(+), 14 deletions(-)

Looks good to me.

Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will
