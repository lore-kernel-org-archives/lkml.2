Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1KTDSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 22:18:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1KTDSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 22:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <1321181347-4391-1-git-send-email-consul.kautuk@gmail.com>
References: <1321181347-4391-1-git-send-email-consul.kautuk@gmail.com>
Date: Sat, 19 Nov 2011 22:18:48 -0500
Message-ID: <CAFPAmTRK6OubP5u_YwcRyyN6vujgqwBaq8-JobdnnYmjEE3Y+g@mail.gmail.com>
Subject: Re: [PATCH 1/1 v4] arm: fault.c: Port OOM changes into do_page_fault
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>
> Port these changes to ARM.

Did anyone get a chance to look at version 4 of this patch ?

I have incorporated changes as suggested by Russell during version 3 review.

Can I improve this patch in any way ?

>
> Without these changes, my ARM board encounters many hang and livelock
> scenarios.
> After applying this patch, OOM feature performance improves according to
> my testing.
>
