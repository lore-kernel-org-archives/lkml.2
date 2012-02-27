Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2B0E5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:57:16 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46375 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab2B0E5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:57:15 -0500
Message-ID: <4F4B0D21.6060002@linux.vnet.ibm.com>
Date: Mon, 27 Feb 2012 12:57:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F338CAA.10807@linux.vnet.ibm.com> <4F338D56.6010505@linux.vnet.ibm.com> <4F42DB8D.7060900@gmail.com>
In-Reply-To: <4F42DB8D.7060900@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022704-4790-0000-0000-000001826329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 07:47 AM, David Ahern wrote:


>> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
>> index 70c2c13..c48ebf3 100644
>> --- a/tools/perf/util/thread.h
>> +++ b/tools/perf/util/thread.h
>> @@ -16,6 +16,8 @@ struct thread {
>>       bool            comm_set;
>>       char            *comm;
>>       int            comm_len;
>> +
>> +    void            *private;
> Arnaldo: Are you ok with this design for now? I can fix this command to whatever API we agree to when it gets committed.


Hi Arnaldo,

What do you think of it? :)


