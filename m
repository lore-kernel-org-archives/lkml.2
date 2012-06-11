Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2FKCrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:47:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56892 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FKCrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:47:15 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-26-4fd55c307461
Message-ID: <4FD55C2E.1020103@lge.com>
Date: Mon, 11 Jun 2012 11:47:10 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] perf tools: Backport of latest changes on trace-cmd's
 libparseevent
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com> <87hauwnash.fsf@sejong.aot.lge.com> <20120531145230.GF13591@infradead.org> <1338476986.13348.347.camel@gandalf.stny.rr.com> <20120531151356.GG13591@infradead.org> <20120531152242.GB27841@somewhere.redhat.com> <20120531153153.GH13591@infradead.org>
In-Reply-To: <20120531153153.GH13591@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

2012-06-01 12:31 AM, Arnaldo Carvalho de Melo wrote:
> Em Thu, May 31, 2012 at 05:22:45PM +0200, Frederic Weisbecker escreveu:
>> On Thu, May 31, 2012 at 12:13:56PM -0300, Arnaldo Carvalho de Melo wrote:
>>> Em Thu, May 31, 2012 at 11:09:46AM -0400, Steven Rostedt escreveu:
>>>> On Thu, 2012-05-31 at 11:52 -0300, Arnaldo Carvalho de Melo wrote:
>>>>> Em Thu, May 31, 2012 at 03:07:26PM +0900, Namhyung Kim escreveu:
>>>>>> It'd be great if you set up a branch for this so that I can continue to
>>>>>> work on it until fully-merged.
>
>>>>> Have you had luck obtaining a git.kernel.org account? It would be better
>>>>> if you used git and maintained such branch :-\
>
>>>> Darn it! I wish I signed his key when I had the chance :-p
>
>>> I did it, Frédéric too, so he should have no problem getting an account,
>>> I think,
>>
>> Except I haven't yet managed to get my korg account back and only Namhyung has
>> signed my key. So I'm not going to be very helpful in this regard ;)
>
> I just checked, he got other sigs, so your chain also should be good to
> go ;-)
>

Now I got an account and setup a tree at 
/pub/scm/linux/kernel/git/namhyung/linux-perf.git. I'll work on further 
libtraceevent improvement on libtraceeevnt/next branch.

Thanks to all you guys to help me setting this up. :)
