Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1GYUcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:32:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39712 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1GYUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:32:11 -0400
Date: Mon, 25 Jul 2011 21:31:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: ARM_PATCH_PHYS_VIRT_16BIT no longer depends
	on MSM
Message-ID: <20110725203114.GF14955@n2100.arm.linux.org.uk>
References: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org> <1311614362-9011-2-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1107251624560.12766@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1107251624560.12766@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 04:25:26PM -0400, Nicolas Pitre wrote:
> On Mon, 25 Jul 2011, Stephen Boyd wrote:
> 
> > MSM no longer requires the 16bit version of dynamic P2V. Drop the
> > dependency.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: David Brown <davidb@codeaurora.org>
> 
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

As it's now unused, we can kill the additional code which makes things
needlessly more complex...
