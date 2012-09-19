Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2ISBxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:53:53 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44775 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2ISBxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:53:51 -0400
Message-ID: <505925A3.60104@linux.vnet.ibm.com>
Date: Wed, 19 Sep 2012 09:53:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, acme@infradead.org,
        mtosatti@redhat.com, avi@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        runzhen@linux.vnet.ibm.com
Subject: Re: [PATCH v8 2/3] perf: move stat related code to util/stat.c
References: <1347870675-31495-1-git-send-email-haodong@linux.vnet.ibm.com> <1347870675-31495-3-git-send-email-haodong@linux.vnet.ibm.com> <5058C91A.1030303@gmail.com>
In-Reply-To: <5058C91A.1030303@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091901-8878-0000-0000-0000040F100C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 03:18 AM, David Ahern wrote:
> On 9/17/12 2:31 AM, Dong Hao wrote:
>> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>
>> Then, the code can be shared between kvm events and perf stat
>>
>> [ Dong Hao <haodong@linux.vnet.ibm.com>: rebase it on acme's git tree ]
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
>> ---
>>   tools/perf/Makefile       |    1 +
>>   tools/perf/builtin-stat.c |   56 +------------------------------------------
>>   tools/perf/util/stat.c    |   57 +++++++++++++++++++++++++++++++++++++++++++++
>>   tools/perf/util/stat.h    |   16 ++++++++++++
>>   4 files changed, 76 insertions(+), 54 deletions(-)
>>   create mode 100644 tools/perf/util/stat.c
>>   create mode 100644 tools/perf/util/stat.h
> 
> Does not apply to Arnaldo's latest perf/core branch.

The patch has already been applied to this branch:
http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=commit;h=0007eceaceb11520071d053acfe06ee3326b1d13

You or we can improve rel_stddev_stats after perf-stat's code is fixed. :)

