Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2ERMLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:11:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51694 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2ERMLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:11:02 -0400
Date: Fri, 18 May 2012 14:10:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        akpm@linux-foundation.org, khlebnikov@openvz.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Set TAINT_UNSAFE_SMP after
 sleep-in-atomic bug
Message-ID: <20120518121056.GD19785@gmail.com>
References: <20120517232210.A292EA02FF@akpm.mtv.corp.google.com>
 <tip-1d76f4381601a259323ad4faadce18db08ddebcd@git.kernel.org>
 <1337338974.573.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337338974.573.27.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2012-05-18 at 03:48 -0700, tip-bot for Konstantin Khlebnikov
> wrote:
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> This is the patch I objected to.. 

Yeah, I fixed it up, the latest one should be fine.

Thanks,

	Ingo
