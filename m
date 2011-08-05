Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1HENlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:41:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42925 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HENlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <1312382996.18583.115.camel@gandalf.stny.rr.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
	<CAJd=RBDiU02XVwDeDwLZ-MNDq_Vn5ONYOFoQz1Fe4EAV9W=1fw@mail.gmail.com>
	<1312382996.18583.115.camel@gandalf.stny.rr.com>
Date: Fri, 5 Aug 2011 21:16:22 +0800
Message-ID: <CAJd=RBB0eHvC8Xnrxax0HGrQ8UmuZ_7Zw-GJ6qhExZyszjojww@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL] sched/cpupri: Remove the vec->lock
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." <lgoncalv@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 10:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Hi Hillf,
>
> Thanks for the ack. But I want to point out this change as something I
> want you to see. Remember when I replied to you with your patches asking
> about benchmarks and timings and other tests? This patch is a good
> example of what I meant.
>
Got and thanks.

Hillf
