Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2JBJOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:14:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53181 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041Ab2JBJN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:13:58 -0400
Date: Tue, 2 Oct 2012 10:13:01 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
Message-ID: <20121002091301.GA8847@mudshark.cambridge.arm.com>
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org>
 <20120920173556.GQ4654@mudshark.cambridge.arm.com>
 <20120924171934.GE5522@mudshark.cambridge.arm.com>
 <506A3694.4070004@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506A3694.4070004@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:34:28AM +0100, Stephen Boyd wrote:
> On 09/24/12 10:19, Will Deacon wrote:
> > Ok, I've pushed a bunch of patches to my hw-breakpoint branch (head commit
> > 55cb726797c7). I'll post them to the list after the merge window, but please
> > do take them for a spin if you get a chance.
> >
> 
> Forgot to reply here. Took them for a spin last week with that commit.
> No more boot hangs but I can't say much else beyond that. When you post
> to the list I'll add my tested-by.

Thanks Stephen. I've also got some patches for OS save/restore of the debug
registers using the various hardware locking and readout mechanisms, so that
debug state can be persisted across low-power states.

Do any of the Qualcomm chips (v7 as opposed to v7.1) implement the save/restore
registers?

Will
