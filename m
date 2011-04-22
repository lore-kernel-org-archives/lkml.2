Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1DVBlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:41:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47865 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab1DVBll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TKvUTvdfiKEPHwsfp0aiyKEwYbIzClA7POBcHFTX1Pl1gOZAHC+QQ19wXLk3v1LHOI
         jJ9snDlaz/R8uzRd58IMV3L2jxnL1ZWw5fwNigPY7StywcpALcVMrbgb6YcdxTZIgAcj
         NiyRJhu91CsEN956K4gdz1+PGBCRL8LIuqRPQ=
MIME-Version: 1.0
In-Reply-To: <1303395845.7181.127.camel@gandalf.stny.rr.com>
References: <20110421014153.126662477@goodmis.org>
	<20110421014259.132728798@goodmis.org>
	<BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
	<1303386029.7181.118.camel@gandalf.stny.rr.com>
	<20110421133541.GB2702@zhy>
	<1303395845.7181.127.camel@gandalf.stny.rr.com>
Date: Fri, 22 Apr 2011 09:41:40 +0800
Message-ID: <BANLkTikBk2n8x1gJBHHrpxZZrhEpVFxt4A@mail.gmail.com>
Subject: Re: [PATCH 1/7] lockdep: Print a nice description of an irq locking issue
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:24 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-04-21 at 21:35 +0800, Yong Zhang wrote:
>> On Thu, Apr 21, 2011 at 07:40:29AM -0400, Steven Rostedt wrote:
>
>> > I
>> > could show the entire chain too.
>>
>> Sure :)
>
> I talked a little about this with Peter Zijlstra on IRC, and we agreed
> that we'll keep this as is until we notice that kernel developers are
> still confused with the output.

OK :)

>
> The more advanced I make this output, the more likely I'll make a
> mistake and show something that is not what actually happens. I wrote a
> module to trigger each of these cases and the problems that lockdep can
> detect grows exponentially as we make the output more specific.
>
> I probably should modify the lockdep selftests to add an option to show
> the output as well as it triggers errors. This would allow me to make
> sure the output still works.

This does make sense to keep things consistent if we have it.

>
> But for now, I have other things to work on ;)

If you want, you can show more details on your ideas,
maybe I could get some time to finish it :)

Thanks,
Yong



-- 
Only stand for myself
