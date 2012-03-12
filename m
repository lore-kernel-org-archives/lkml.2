Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab2CLT6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:58:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41248 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756287Ab2CLT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:58:24 -0400
Message-ID: <4F5E554C.4060209@fb.com>
Date: Mon, 12 Mar 2012 12:58:04 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <4F5DA91F.7060908@lge.com> <4F5E3E8C.1020005@fb.com>
In-Reply-To: <4F5E3E8C.1020005@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-12_05:2012-03-12,2012-03-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 11:21 AM, Arun Sharma wrote:

>>
>> BTW, I don't like the name 'inclusive' as a sort key. If it cares about
>> time, IMHO, the name should contain 'time' - something like 'itime' or
>> 'inctime'?
>
> The existing sort orders: pid, comm, dso, symbol, parent -- all care
> about time, but none of them have time in their name?

I'll take that back. What they sort on depends on the event.

perf record -ge cache-misses
perf report -s inclusive

will sort by the number of cache-misses and not time.

  -Arun
