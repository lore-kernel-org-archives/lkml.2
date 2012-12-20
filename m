Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab2LTHjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:39:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56923 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2LTHjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:39:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="15495776"
Message-ID: <50D2C0B6.9090702@codeaurora.org>
Date: Wed, 19 Dec 2012 23:39:34 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: pjt@google.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>
Subject: Re: [patch 00/16] sched: per-entity load-tracking
References: <20120823141422.444396696@google.com> <CABb+yY2Cr=mvVW=m12uOaLTydE8j3iB2m0wrVt0gOrO3tz+mZA@mail.gmail.com>
In-Reply-To: <CABb+yY2Cr=mvVW=m12uOaLTydE8j3iB2m0wrVt0gOrO3tz+mZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 5:08 AM, Jassi Brar wrote:
> The patchset introduces 64-bit atomic ops, which would need
> init_atomic64_lock() already called, but that is an initcall made too
> late. Should we consider calling init_atomic64_lock() sooner in
> start_kernel()?
>
> As an example of breakage, I see the following dump with
> CONFIG_DEBUG_SPINLOCK on an OMAP based Pandaboard.

I saw this post while searching lkml for similar problems. Perhaps you
can try applying my patch to see if this BUG message goes away. Thanks.

https://lkml.org/lkml/2012/12/19/302

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

