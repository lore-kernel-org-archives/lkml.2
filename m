Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2CMBQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:16:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2CMBQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:16:46 -0400
X-AuditID: 9c930179-b7b92ae000005ed3-9e-4f5e9ffb00f8
Message-ID: <4F5E9FFA.7060300@lge.com>
Date: Tue, 13 Mar 2012 10:16:42 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.perf.user,gmane.linux.kernel
To: Arun Sharma <asharma@fb.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <4F5DA91F.7060908@lge.com> <4F5E3E8C.1020005@fb.com>
In-Reply-To: <4F5E3E8C.1020005@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-03-13 3:21 AM, Arun Sharma wrote:
> On 3/12/12 12:43 AM, Namhyung Kim wrote:
>
>>> Known bugs:
>>>
>>> total_period computation is broken for order=callee
>>>
>>
>> I'd like to add two more :).
>>
>> * If perf record misses callchain info, perf report will get stuck.
>> * If it's used with "symbol" sort order, it'll get stuck too.
>>
>
> Can you post the command lines you used to reproduce this? A backtrace on
> where perf report is getting stuck would be useful as well.
>

$ perf record sleep 1
$ perf report -s inclusive

and

$ perf record -g sleep 1
$ perf report -s inclusive,symbol


Thanks,
Namhyung

