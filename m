Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1G2KdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:33:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48839 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab1G2Kc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:32:59 -0400
Date: Fri, 29 Jul 2011 11:32:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 2/2] ARM: msm: Remove PLAT_PHYS_OFFSETS from MSM targets
Message-ID: <20110729103239.GC25640@n2100.arm.linux.org.uk>
References: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org> <1311884291-5409-1-git-send-email-davidb@codeaurora.org> <1311884291-5409-2-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311884291-5409-2-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 01:18:11PM -0700, David Brown wrote:
> Now that MSM can boot with the phys offset patching, eliminate the
> definitions of the phys offsets, and instead select
> ARM_PATCH_PHYS_VIRT.

I think it may be better to remove the EXPERIMENTAL status of
ARM_PATCH_PHYS_VIRT, and make the option default to 'y' now, so that
we start building all kernels with this enabled.  If people don't
want it (and know what they're doing) they can disable it manually
(maybe make the option only appear for EXPERT).

Lets see about that after this merge window is over.
