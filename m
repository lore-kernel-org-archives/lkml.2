Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1BBS3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:29:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61061 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab1BBS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:29:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="72731457"
From: David Brown <davidb@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-Reply-To: <20110131131401.5d6c7646.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 31 Jan 2011 13:14:01 +1100")
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110202:sfr@canb.auug.org.au::efnQ+2mprzjBgQix:000000000000000000000000000000000000000000Ump
X-Hashcash: 1:20:110202:rmk@arm.linux.org.uk::p4lnNU08DufPz3QS:000000000000000000000000000000000000000001zaW
X-Hashcash: 1:20:110202:stepanm@codeaurora.org::BGIhe6QmKfaailb0:0000000000000000000000000000000000000001/5t
X-Hashcash: 1:20:110202:linux-kernel@vger.kernel.org::mw6iGTkltP/6nVUm:0000000000000000000000000000000004wVf
X-Hashcash: 1:20:110202:linux-next@vger.kernel.org::asuA3AqG8TTW4RmL:000000000000000000000000000000000006nKh
Date: Wed, 02 Feb 2011 10:29:14 -0800
Message-ID: <8ya4o8m70jp.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30 2011, Stephen Rothwell wrote:

> Hi David,
>
> Today's linux-next merge of the msm tree got conflicts in
> arch/arm/mach-msm/board-msm7x27.c, arch/arm/mach-msm/board-msm7x30.c,
> arch/arm/mach-msm/board-qsd8x50.c and arch/arm/mach-msm/board-sapphire.c
> between commit eda53d6d032effb653410b79e1b49e652a881744 ("ARM: P2V: avoid
> initializers and assembly using PHYS_OFFSET") from the arm tree and
> commit 07a3cc4814f790354d4c7be2c9dc6143a714a07a ("msm: Clean up useless
> ifdefs") from the msm tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

What is the best way to resolve this?  I can't really merge against
Russell's tree, since he may need to rebase his tree before the merge
window?  Or is it best to just have you carry the conflict resolution in
linux-next, and I make the resolution during the next merge window?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
