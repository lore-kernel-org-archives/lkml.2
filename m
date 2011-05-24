Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab1EXNJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:09:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1EXNJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:09:39 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=bq_J3biGYC0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=_xfTZj9QwyJqPCq0EBkA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove noop in next_prio()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 May 2011 09:09:36 -0400
Message-ID: <1306242576.1465.53.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 22:19 +0800, Hillf Danton wrote:
> When computing the next priority for a given run-queue, the check for
> RT priority of the task determined by the pick_next_highest_task_rt()
> function could be removed, since only RT task is returned by the
> function.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


