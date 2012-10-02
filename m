Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2JBAeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:34:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31123 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2JBAe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:34:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6852"; a="244294183"
Message-ID: <506A3694.4070004@codeaurora.org>
Date: Mon, 01 Oct 2012 17:34:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org> <20120920173556.GQ4654@mudshark.cambridge.arm.com> <20120924171934.GE5522@mudshark.cambridge.arm.com>
In-Reply-To: <20120924171934.GE5522@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/12 10:19, Will Deacon wrote:
> Ok, I've pushed a bunch of patches to my hw-breakpoint branch (head commit
> 55cb726797c7). I'll post them to the list after the merge window, but please
> do take them for a spin if you get a chance.
>

Forgot to reply here. Took them for a spin last week with that commit.
No more boot hangs but I can't say much else beyond that. When you post
to the list I'll add my tested-by.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

