Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0LGXrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 18:47:47 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40400 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0LGXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 18:47:46 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] trace syscalls: Remove redundant syscall_nr checks
From: Ian Munsie <imunsie@au1.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
In-reply-to: <1291733682.16223.244.camel@gandalf.stny.rr.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com> <1291696151-4336-3-git-send-email-imunsie@au1.ibm.com> <1291733682.16223.244.camel@gandalf.stny.rr.com>
Date: Wed, 08 Dec 2010 10:47:42 +1100
Message-Id: <1291765620-sup-3222@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Steven Rostedt's message of Wed Dec 08 01:54:42 +1100 2010:
> On Tue, 2010-12-07 at 15:29 +1100, Ian Munsie wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > With the ftrace events now checking if the syscall_nr is valid upon
> > initialisation, there is no need to verify it when registering and
> > unregistering the events, so remove the check.
> 
> I still like to keep these checks. I don't mind redundant checks that
> are in slow paths, as they may catch a bug on a change in the future.
> 
> What you could do is change these to:
> 
>     if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))

Hi Steve,

Thanks for the feedback. Will update and resubmit.

Cheers,
-Ian
