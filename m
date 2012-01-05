Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab2AEOZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:25:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33469 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2AEOZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:25:13 -0500
Message-ID: <1325773505.2697.61.camel@twins>
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated
 during context switching
From: Peter Zijlstra <peterz@infradead.org>
To: Chanho Min <chanho0207@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        chanho.min@lge.com
Date: Thu, 05 Jan 2012 15:25:05 +0100
In-Reply-To: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 20:00 +0900, Chanho Min wrote:
> In recent ARM, I saw the patch to remove
> __ARCH_WANT_INTERRUPTS_ON_CTXSW is posted.
> But, if that feature is adopted by the others architecture 

No, the moment ARM removes the need, the whole feature will be removed
never to be brought back, its a horrid complication to the scheduler we
really don't ever want to bring back (like you found out).

I'll go and digest your scenario now. At the very least your patch might
want to go into -stable.
