Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1LFVxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:53:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33755 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab1LFVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:53:17 -0500
Message-ID: <4EDE8EBD.2070104@fb.com>
Date: Tue, 6 Dec 2011 13:53:01 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>, <mingo@elte.hu>,
        William Cohen <wcohen@redhat.com>, Vince Weaver <vince@deater.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
References: <20111121145114.049265181@chello.nl> <4ED9267F.10106@fb.com>  <CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com>  <4EDD26B9.8070007@fb.com> <4EDD50F5.30300@fb.com> <1323164549.32012.50.camel@twins>
In-Reply-To: <1323164549.32012.50.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-06_04:2011-12-06,2011-12-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/11 1:42 AM, Peter Zijlstra wrote:
> On Mon, 2011-12-05 at 15:17 -0800, Arun Sharma wrote:
>>
>> I suspect that some optimizations are possible in perf_rotate_context
>> that don't involve enabling/disabling the PMU via an IPI for simple
>> cases that involve one or two hardware events (eg: fixed counters).
>
> I've got a patch queued that does exactly that.

Verified that this fixes the lat_ctx regression. Thanks.

  -Arun

