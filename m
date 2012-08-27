Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2H0QJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:09:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37810 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2H0QJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:09:00 -0400
Date: Mon, 27 Aug 2012 18:08:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] oprofile: Remove 'WQ on CPUx, prefer CPUy' warning
Message-ID: <20120827160854.GC16230@one.firstfloor.org>
References: <1345834411-24940-1-git-send-email-robert.richter@amd.com> <1345834411-24940-3-git-send-email-robert.richter@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345834411-24940-3-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 08:53:31PM +0200, Robert Richter wrote:
> Under certain workloads we see the following warnings:
> 
>  WQ on CPU0, prefer CPU1
>  WQ on CPU0, prefer CPU2
>  WQ on CPU0, prefer CPU3
> 
> It warns the user that the wq to access a per-cpu buffers runs not on
> the same cpu. This happens if the wq is rescheduled on a different cpu
> than where the buffer is located. This was probably implemented to
> detect performance issues. Not sure if there actually is one as the
> buffers are copied to a single buffer anyway which should be the
> actual bottleneck.
> 
> We wont change WQ implementation. Since a user can do nothing the
> warning is pointless. Removing it.

Looks good to me.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
