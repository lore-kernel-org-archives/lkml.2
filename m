Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1CTJ0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 05:26:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53240 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1CTJ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 05:26:38 -0400
Date: Sun, 20 Mar 2011 09:26:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: Merge v6 and v7 DEBUG_LL DCC support
Message-ID: <20110320092629.GB16646@n2100.arm.linux.org.uk>
References: <1300416720-16305-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300416720-16305-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 07:52:00PM -0700, Stephen Boyd wrote:
> The inline assembly differences for v6 vs. v7 are purely
> optimizations. On a v7 processor, an mrc with the pc sets the
> condition codes to the 28-31 bits of the register being read. It
> just so happens that the TX/RX full bits the DCC support code is
> testing for are high enough in the register to be put into the
> condition codes. On a v6 processor, this "feature" isn't
> implemented and thus we have to do the usual read, mask, test
> operations to check for TX/RX full. Thus, we can drop the v7
> implementation and just use the v6 implementation for both.

This patch needs updating for the changes that were in my tree for many
months, and are now in mainline.
