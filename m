Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1FJCis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 22:38:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56998 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab1FJCip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 22:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EtLT3k6KYMCZhu6GA47v4l+ZEGok2UOk6H42LYKpzDNMCHSBuomxvQWA40/soLezU/
         Hh5VQgg1M4eAQWDoFIYTXnuazlQHlEQKPrbKYbmorkySxNeA1JnCts06AEPWC8j8s3TD
         5KLh/LQUyrMw0Z1lZNVLdYSdZJp5U34WudixY=
MIME-Version: 1.0
In-Reply-To: <1307622863.9218.40.camel@gandalf.stny.rr.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	<BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
	<1307622863.9218.40.camel@gandalf.stny.rr.com>
Date: Fri, 10 Jun 2011 10:38:44 +0800
Message-ID: <BANLkTi=Y+0h9bMaT6Z4+MhHf==POMKJNoQ@mail.gmail.com>
Subject: Re: [PATCH] sched: remove resetting exec_start in put_prev_task_rt()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> I disagree. Yes the exec_start is reset there, but I like the fact that
> it's 0 when not running.

Actually this depends on how we look at the code:
if we set exec_start to 0 explicitly, as you said the code is more direct and
readable.
if we don't set exec_start to 0, we can save one instruction though
it's minor.

I have no strong opinion on either of them :)

BTW, put_prev_task_fair() doesn't set exec_start to 0.

Thanks,
Yong


-- 
Only stand for myself
