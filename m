Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2HNCNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:13:09 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35598 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2HNCNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:13:07 -0400
Message-ID: <5029B429.2070901@linux.vnet.ibm.com>
Date: Tue, 14 Aug 2012 10:12:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, avi@redhat.com, acme@infradead.org,
        mtosatti@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/3] KVM: perf kvm events analysis tool
References: <1344568750-5147-1-git-send-email-haodong@linux.vnet.ibm.com> <1344568750-5147-4-git-send-email-haodong@linux.vnet.ibm.com> <502570F5.3080903@gmail.com>
In-Reply-To: <502570F5.3080903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081402-8256-0000-0000-000003B3F02C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2012 04:37 AM, David Ahern wrote:
> Thanks for resubmitting this; it was on my to-do list as well.

Thanks for you liking it and your precious comments, David! :)

> 
> On 8/9/12 9:19 PM, Dong Hao wrote:
>> +static bool kvm_events_exist(const char *event)
>> +{
>> +    char evt_path[MAXPATHLEN];
>> +    int fd;
>> +
>> +    snprintf(evt_path, MAXPATHLEN, "%s/kvm/%s/id", tracing_events_path,
>> +         event);
>> +
>> +    fd = open(evt_path, O_RDONLY);
> 
> Use is_valid_tracepoint().

Fine to us, will do it in the next version.

