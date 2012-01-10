Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2AJJmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:42:51 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51777 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2AJJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:42:50 -0500
X-AuditID: 9c930197-b7bf2ae000001470-54-4f0c0817d565
Message-ID: <4F0C0817.6030307@lge.com>
Date: Tue, 10 Jan 2012 18:42:47 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Chanho Min <chanho0207@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        chanho.min@lge.com
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated during
 context switching
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>  <1325786132.3508.1.camel@twins>  <1325787342.12696.59.camel@gandalf.stny.rr.com>  <1325799904.3508.12.camel@twins>  <CAOAMb1A3DNU87oFRHPJZc5OARtsN4wjarmr+Ffu9oB_b0HOioA@mail.gmail.com> <1326187433.2442.101.camel@twins>
In-Reply-To: <1326187433.2442.101.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-10 6:23 PM, Peter Zijlstra wrote:
> On Tue, 2012-01-10 at 17:13 +0900, Chanho Min wrote:
>> So Will this be applied?  It will be critical and very hard to debug.
>> ( pretty rare, sometimes system hang without any message )
>> It has been well tested on our ARM platform.
>>
>>
> Yeah, thanks. I've queued it, should show up in -tip soonish.

It seems it should go into -stable as well, right?


Thanks,
Namhyung Kim
