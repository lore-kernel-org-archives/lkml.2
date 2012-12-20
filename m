Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2LTIa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:30:29 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44972 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2LTIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:30:23 -0500
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 03:30:23 EST
MIME-Version: 1.0
In-Reply-To: <50D2C0B6.9090702@codeaurora.org>
References: <20120823141422.444396696@google.com>
	<CABb+yY2Cr=mvVW=m12uOaLTydE8j3iB2m0wrVt0gOrO3tz+mZA@mail.gmail.com>
	<50D2C0B6.9090702@codeaurora.org>
Date: Thu, 20 Dec 2012 13:38:18 +0530
Message-ID: <CABb+yY2V0EZiDGmrB1fer0a8Kwng-gnKbkhFfuVUpgOZkbCRKg@mail.gmail.com>
Subject: Re: [patch 00/16] sched: per-entity load-tracking
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: pjt@google.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 1:09 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 11/26/2012 5:08 AM, Jassi Brar wrote:
>> The patchset introduces 64-bit atomic ops, which would need
>> init_atomic64_lock() already called, but that is an initcall made too
>> late. Should we consider calling init_atomic64_lock() sooner in
>> start_kernel()?
>>
>> As an example of breakage, I see the following dump with
>> CONFIG_DEBUG_SPINLOCK on an OMAP based Pandaboard.
>
> I saw this post while searching lkml for similar problems. Perhaps you
> can try applying my patch to see if this BUG message goes away. Thanks.
>
> https://lkml.org/lkml/2012/12/19/302
>
Yes, this should do too.
