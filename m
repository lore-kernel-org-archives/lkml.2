Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1LVAS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:18:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32980 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754392Ab1LVAS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:18:26 -0500
Message-ID: <4EF2773E.4070308@fb.com>
Date: Wed, 21 Dec 2011 16:18:06 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <avagin@openvz.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing, sched: Add a new tracepoint for sleeptime
References: <1324404558-353-1-git-send-email-asharma@fb.com> <1324404558-353-3-git-send-email-asharma@fb.com> <4EF1B86D.9030809@openvz.org>
In-Reply-To: <4EF1B86D.9030809@openvz.org>
Content-Type: text/plain; charset="KOI8-R"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-21_08:2011-12-21,2011-12-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/11 2:43 AM, Andrey Vagin wrote:

> Arun, probably you have missed one of my comments.
> block_start and sleep_start should be zeroized here.
>
> tsk->se.statistics.block_start = 0;
> tsk->se.statistics.sleep_start = 0;
>
> The following program provokes this problem:

Yes - I overlooked the comment. Thanks for bringing it up (especially 
the test program). Fixed in v3.

  -Arun
