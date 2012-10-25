Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2JYM3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:29:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40020 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757054Ab2JYM3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:29:05 -0400
Date: Thu, 25 Oct 2012 13:27:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCHv3] ARM: Sort exception table at compile time
Message-ID: <20121025122754.GF11267@mudshark.cambridge.arm.com>
References: <1351125882-13046-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351125882-13046-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:44:42AM +0100, Stephen Boyd wrote:
> Add the ARM machine identifier to sortextable and select the
> config option so that we can sort the exception table at compile
> time. sortextable relies on a section named __ex_table existing
> in the vmlinux, but ARM's linker script places the exception
> table in the data section. Give the exception table its own
> section so that sortextable can find it.
> 
> This allows us to skip the sorting step during boot.
> 
> Cc: David Daney <david.daney@cavium.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Just had a play with this for my A15 platform and it seems to work fine when
targetting either ARM or Thumb-2 kernels.

Tested-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will
