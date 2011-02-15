Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab1BOPso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:48:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49563 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1BOPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:48:42 -0500
Date: Tue, 15 Feb 2011 15:48:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20110215154819.GO4152@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-16-git-send-email-catalin.marinas@arm.com> <20110212102803.GC15616@n2100.arm.linux.org.uk> <1297770742.21448.2.camel@e102144-lin.cambridge.arm.com> <20110215123522.GH4152@n2100.arm.linux.org.uk> <1297773569.14691.36.camel@e102109-lin.cambridge.arm.com> <1297777027.1293.2.camel@e102144-lin.cambridge.arm.com> <20110215142339.GL4152@n2100.arm.linux.org.uk> <1297783609.23889.6.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297783609.23889.6.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 03:26:49PM +0000, Will Deacon wrote:
> The conflict with the p2v branch is fairly hefty, but something like
> this should do (if you're happy I'll submit it to replace 6670/1):

I was thinking that was the case - which is why I wanted this split up
so this can be tackled separately.

> Note that because the v2p macros only work for lowmem, I've not bothered
> to add casts for the __v2p macros (rather, I've just changed the types
> of the static inline functions). This simplifies the code and means we
> can stay clear of the runtime fixup stuff.

This patch looks good enough, thanks.
