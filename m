Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2FDRDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:03:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41772 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753013Ab2FDRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:03:08 -0400
Message-ID: <4FCCEA4E.5060102@fb.com>
Date: Mon, 4 Jun 2012 10:03:10 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Vagin <avagin@openvz.org>
CC: Oleg Strikov <OSTRIKOV@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1338797382-287275-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-06-04_03:2012-05-21,2012-06-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/12 1:09 AM, Andrew Vagin wrote:
>
> * "sched/tracing: Add a new tracepoint for sleeptime" by Arun Sharma
> It has been committed, but then reverted due to performance reason.

Correctness actually. The first sample could potentially be bogus and 
needs to be discarded in userspace. Hasn't been a problem in practice 
for us.

  -Arun
