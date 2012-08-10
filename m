Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2HJI5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:57:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45829 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2HJI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:57:48 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-e6-5024cd0a4ffc
From: Namhyung Kim <namhyung@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC/PATCH] sched: Honor sync wake up in select_idle_sibling
References: <1344583512-25352-1-git-send-email-namhyung@kernel.org>
	<1344586484.4330.24.camel@marge.simpson.net>
Date: Fri, 10 Aug 2012 17:51:58 +0900
In-Reply-To: <1344586484.4330.24.camel@marge.simpson.net> (Mike Galbraith's
	message of "Fri, 10 Aug 2012 10:14:44 +0200")
Message-ID: <87boijw2mp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

On Fri, 10 Aug 2012 10:14:44 +0200, Mike Galbraith wrote:
> On Fri, 2012-08-10 at 16:25 +0900, Namhyung Kim wrote: 
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> When sync wakeup happens and there's the waker task running alone,
>> select the target cpu as if it's already idle.
>
> Ouch.  That defeats the purpose of select_idle_sibling().  Just because
> we're doing a sync wakeup does not mean there's no convertible overlap,
> nor that the waker is really really going to take a nap immediately.  A
> lot of the places that benefit up to and including hugely from looking
> for an idle shared cache to wake to do sync wakeups.

Thanks for the explanation! I misunderstood the function ;)

Thanks,
Namhyung

