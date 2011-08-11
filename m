Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1HKJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:32:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43337 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1HKJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:32:25 -0400
Date: Thu, 11 Aug 2011 10:32:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv4 2/2] ARM: P2V: Remove ARM_PATCH_PHYS_VIRT_16BIT
Message-ID: <20110811093204.GE4775@n2100.arm.linux.org.uk>
References: <1311794355-26988-1-git-send-email-sboyd@codeaurora.org> <1311794355-26988-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:19:15PM -0700, Stephen Boyd wrote:
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> 
> This code can be removed now that MSM targets no longer need the 16-bit
> offsets for P2V.
> 
> Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Can you submit these two patches to the patch system so they can be
integrated with the patch to enable by default the p2v patching please?

You will need to update then against my for-next branch to account for
that change - it should only be context changes in arch/arm/Kconfig.

Thanks.
