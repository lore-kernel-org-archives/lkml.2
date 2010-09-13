Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0IMW4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 18:56:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52935 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0IMW4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 18:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CS9f4+51OmTc7kfWeDKmqevId7SpMldcgOcbn6FzOaGgXhGq8uZD6VJrORXKs7LFcH
         L2rcIdiAi0Ig6DpG6pJou+VRyM8cbNB3e/3W5rjhZrgJf3BMBa6CtyYk9TJmSJ+mWDUY
         noYhh3zk08HkUION+AsBO7bODV5kSqA3V9Lg0=
MIME-Version: 1.0
In-Reply-To: <20100913084619.GC23741@elte.hu>
References: <1284150773.402.122.camel@laptop>
	<tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
	<20100913074233.GA2674@schottelius.org>
	<20100913084619.GC23741@elte.hu>
Date: Tue, 14 Sep 2010 06:56:42 +0800
Message-ID: <AANLkTikN5AxqmdHhkkrE9SmhaMxkFjRXnOSguyeJDtXM@mail.gmail.com>
Subject: Re: [tip:sched/urgent] x86, tsc: Fix a preemption leak in restore_sched_clock_state()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org, flo@xssn.at,
        lenb@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 4:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nico Schottelius <nico-linux-20100709@schottelius.org> wrote:
>
>> Good morning,
>>
>> tip-bot for Peter Zijlstra [Sat, Sep 11, 2010 at 07:49:07AM +0000]:
>> > Commit-ID:  55496c896b8a695140045099d4e0175cf09d4eae
>> > Gitweb:     http://git.kernel.org/tip/55496c896b8a695140045099d4e0175cf09d4eae
>> > Author:     Peter Zijlstra <peterz@infradead.org>
>> > AuthorDate: Fri, 10 Sep 2010 22:32:53 +0200
>> > Committer:  Ingo Molnar <mingo@elte.hu>
>> > CommitDate: Sat, 11 Sep 2010 09:47:07 +0200
>> >
>> > x86, tsc: Fix a preemption leak in restore_sched_clock_state()

> Might make sense to bisect it ... as long as you remember to do this at
> every bisection step that has the hung-suspend bug:

Have you tried just running "echo mem >/sys/power/state" to see if that works?

Jeff.
