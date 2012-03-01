Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2CAXs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 18:48:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10359 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2CAXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 18:48:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6636"; a="168339888"
Date: Thu, 1 Mar 2012 17:48:24 -0600
From: Richard Kuo <rkuo@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, benh@kernel.crashing.org,
        paulus@samba.org, asharma@fb.com, vapier@gentoo.org,
        eric.dumazet@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 1/2] atomic: Allow atomic_inc_not_zero to be overridden
Message-ID: <20120301234824.GC2644@codeaurora.org>
References: <20120301180953.0f61576f@kryten>
 <20120301150256.9a7d0b06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301150256.9a7d0b06.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 03:02:56PM -0800, Andrew Morton wrote:
> Please merge this via the ppc tree?
> 
> 
> And let's ask the hexagon maintainers to take a look at the definition
> in arch/hexagon/include/asm/atomic.h.  I assume that it can be removed,
> but that might cause problems with files which include asm/atomic.h
> directly.  I have found two such files in non-arch code and have queued
> fixes.  There are no such files in arch/hexagon code, so I think it's
> safe to zap the hexagon definition of atomic_inc_not_zero().

Just tested it; it's safe to zap the Hexagon definition of
atomic_inc_not_zero()...  I'm fine with this going in through some
other tree (still getting mine set up).


Thanks,
Richard Kuo




-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
