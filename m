Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1LUAvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:51:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35515 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753751Ab1LUAvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:51:02 -0500
Message-ID: <4EF12D58.4000105@fb.com>
Date: Tue, 20 Dec 2011 16:50:32 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
References: <cover.1323739287.git.luto@amacapital.net>
In-Reply-To: <cover.1323739287.git.luto@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-20_08:2011-12-20,2011-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 5:26 PM, Andy Lutomirski wrote:
> On x86-64, clock_gettime is so fast that the overhead converting to and
> from nanoseconds is non-negligible.  clock_gettime_ns is a different
> interface that is potentially faster.  If people like the ABI, I'll
> implement an optimized version.

Didn't see any major objections to this proposal.

Andy: will you be posting an optimized version?

  -Arun

