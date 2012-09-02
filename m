Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2IBVWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:22:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55945 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2IBVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <87a9xci9g1.fsf@dasan.aot.lge.com>
References: <CANg8OWKBjawB4DQK=NQsYKYcOffA30L7Mgm5oiVjnKvMVR2AZw@mail.gmail.com>
 <87a9xci9g1.fsf@dasan.aot.lge.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Mon, 3 Sep 2012 00:21:58 +0300
Message-ID: <CANg8OW+yPDtO89f9QSS=-=kxTwHqPf2+GqTCsnXjyxGbju60cw@mail.gmail.com>
Subject: Re: [PATCH 00/13] Porting perf to Android
To: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 8:19 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Irina Tirdea <irina.tirdea@gmail.com> writes:
>
>> Hi,
>>
>> This is a set of patches to port perf to Android.
>> My approach is to include missing functions in Android (like getline,
>> getsid, etc). I am currently working on upstreaming these to Google.
>> With the missing functionality added to bionic, this compiles on latest
>> Android tree (JellyBean). This will make perf compile, but there are still
>> fixes needed at runtime which I am currently working on.
>
> Yeah, I guess the callchain part which uses TLS is the one of them. Do
> you have an idea how to deal with it?

Yes, TLS defined through __thread is not supported by bionic. I was
thinking of using pthread_getspecific/pthread_setspecific API instead.

Thanks,
Irina
