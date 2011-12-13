Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1LMSQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:16:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49314 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017Ab1LMSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:16:23 -0500
Message-ID: <4EE7962E.90204@fb.com>
Date: Tue, 13 Dec 2011 10:15:10 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, <linux-kernel@vger.kernel.org>,
        Kumar Sundararajan <kumar@fb.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com>    <1323718578-1157-3-git-send-email-asharma@fb.com>   <1323720791.2583.23.camel@edumazet-laptop> <4EE66FE9.1050202@fb.com>  <1323725243.2583.27.camel@edumazet-laptop> <4EE67CB5.7000404@fb.com> <1323766358.9082.0.camel@twins>
In-Reply-To: <1323766358.9082.0.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-13_03:2011-12-13,2011-12-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/11 12:52 AM, Peter Zijlstra wrote:
> On Mon, 2011-12-12 at 14:14 -0800, Arun Sharma wrote:
>
>>> But really most modern distros have NR_CPUS>   64
>>
>> Is 256 the new 64? :)
>
> 4096 in fact.

Not sure if you're asking for vsyscall support for NR_CPUS=4096 case or 
just a compile fix + disabled vsyscall is ok.

  -Arun
