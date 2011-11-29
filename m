Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1K2NRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:17:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:42933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1K2NRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:17:18 -0500
Message-ID: <1322572622.2921.231.camel@twins>
Subject: Re: [PATCH 1/1] sched/rt: code cleanup, remove a redundant function
 call
From: Peter Zijlstra <peterz@infradead.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Date: Tue, 29 Nov 2011 14:17:02 +0100
In-Reply-To: <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
References: <1322535836-13590-1-git-send-email-haishan.bai@gmail.com>
	 <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 11:03 +0800, Shan Hai wrote:
> The second time call to sched_rt_period is redundant, because the value of the
> rt_runtime was already read and it was protected by the rurt_runtime_lock.
> 
> Signed-off-by: Shan Hai <haishan.bai@gmail.com>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Note that that file doesn't exist anymore, scheduler patches should be
posted against tip/master.

Anyway, fixed that up and applied it. Thanks!
