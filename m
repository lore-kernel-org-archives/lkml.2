Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2AZSXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:23:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52049 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753348Ab2AZSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:23:13 -0500
Message-ID: <4F2199E4.3020107@fb.com>
Date: Thu, 26 Jan 2012 10:22:28 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <mingo@elte.hu>, <gleb@redhat.com>, <wcohen@redhat.com>,
        <vince@deater.net>, <andi@firstfloor.org>
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
References: <20120126160319.GA5655@quad> <1327594589.2446.112.camel@twins>
In-Reply-To: <1327594589.2446.112.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-26_07:2012-01-26,2012-01-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/12 8:16 AM, Peter Zijlstra wrote:
> On Thu, 2012-01-26 at 17:03 +0100, Stephane Eranian wrote:
>> This patch fixes the throttling mechanism. It was broken
>> in 3.2.0. Events were not being unthrottled. The unthrottling
>> mechanism required that events be checked at each timer tick.
>>
>> This patch solves this problem and also separates:
>>    - unthrottling
>>    - multiplexing
>>    - frequency-mode period adjustments
>
> Thanks!

Should this be Cc'ed to stable@?

  -Arun
