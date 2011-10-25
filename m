Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1JYUvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:51:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23237 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1JYUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:51:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6510"; a="130834275"
Date: Tue, 25 Oct 2011 13:50:53 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] msm: boards: Fix fallout from removal of machine_desc
 in fixup
Message-ID: <20111025205053.GA15649@huya.qualcomm.com>
References: <1319560519-18899-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319560519-18899-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 09:35:19AM -0700, Stephen Boyd wrote:
> After 0744a3ee (ARM: platform fixups: remove mdesc argument to
> fixup function, 2010-12-20) the fixup functions introduced in
> 9e775ad (ARM: 7012/1: Set proper TEXT_OFFSET for newer MSMs,
> 2011-08-12) cause warnings like:
> 
> arch/arm/mach-msm/board-msm8x60.c:85: warning: initialization
> from incompatible pointer type
> 
> Fix them by removing the machine_desc argument from the fixup
> functions.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Yes, these got missed among the merges.

Acked-by: David Brown <davidb@codeaurora.org>

Russell, would you prefer this to go through your tracker, or for me
to push this to Arnd?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
