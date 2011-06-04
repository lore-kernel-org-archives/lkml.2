Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1FDE0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 00:26:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55404 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1FDE0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 00:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uyALhjdx9t0spukLRukIq1jCbTT7lS0rFV9AafBob6dScfZ/GxFFaDT7b6BtZUdqTq
         8bDl6dUvC19yh6tRG0GJArqvf0+X+4L7h1u/wXcaZ7k3sJ87vCfnjqd91IcYC5pdJfOj
         0Ax+p4y3BcKw2NlJfkvnnXLp3yerR+uG+gEjI=
MIME-Version: 1.0
In-Reply-To: <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	<BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
Date: Sat, 4 Jun 2011 12:26:18 +0800
Message-ID: <BANLkTikx9gENppLG4xwYOKSoFyhY+xXS=Q@mail.gmail.com>
Subject: Re: [PATCH] sched: remove resetting exec_start in put_prev_task_rt()
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 4:04 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Wed, Jun 1, 2011 at 10:03 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> Resetting exec_start, after updated in update_curr_rt(), could open window for
>> messing up the subsequent computations of delta_exec of the given task.
>
> I can't see how could this happen. what kind of 'subsequent computations'
> do you mean?
>
> But because exec_start will be reset by _pick_next_task_rt()/set_curr_task_rt(),
> you patch is ok. IMHO it is not critical, it's just cleanup instead.
>

H i Yong

The window is closed in the two cases, as you tip fingered, would you please
say a few more words about the window and tick timer?

thanks
           Hillf
