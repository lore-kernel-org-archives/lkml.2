Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1LMA0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:26:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56027 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753685Ab1LMA0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:26:49 -0500
Message-ID: <4EE69BAB.9010302@fb.com>
Date: Mon, 12 Dec 2011 16:26:19 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com>  <1323718578-1157-3-git-send-email-asharma@fb.com>  <1323731361.4078.102.camel@work-vm> <4EE68C31.1030207@fb.com> <1323732772.4078.113.camel@work-vm>
In-Reply-To: <1323732772.4078.113.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_10:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 3:32 PM, john stultz wrote:

> Is it just that you're concerned about the clockid switch costs being
> too high?

Yeah - but I have no real-world data to back it up (I don't think micro 
benchmarks are a good way to analyze this).

clock_gettime_ns() may just be the right answer here.

  -Arun
