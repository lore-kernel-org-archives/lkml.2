Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2BNFsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:48:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49134 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2BNFsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:48:50 -0500
X-AuditID: 9c930179-b7cf1ae000000e40-a5-4f39f5beb62e
Message-ID: <4F39F5BC.6000605@lge.com>
Date: Tue, 14 Feb 2012 14:48:44 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Ahern <dsahern@gmail.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Namhyung Kim <namhyung@gmail.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
References: <1329184375-27911-1-git-send-email-acme@infradead.org> <4F39CBE0.6050806@gmail.com> <4F39D00D.2060206@gmail.com> <4F39ECDB.5090609@lge.com> <4F39EFBB.2010301@gmail.com>
In-Reply-To: <4F39EFBB.2010301@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-02-14 2:23 PM, David Ahern wrote:
> On 2/13/12 10:10 PM, Namhyung Kim wrote:
>>>
>>
>> It happened because I used old kernel version that isn't aware of the
>> exclude_guest bit. So the check on attr->__reserved_1 in
>> core.c::perf_copy_attr() failed and then ended up seeing EINVAL at
>> perf_evsel__open().
>
> comes back to 1aed2671738785e8f5aea663a6fda91aa7ef59b5 again. See
>
> https://lkml.org/lkml/2012/2/8/234
>

Thanks for the pointer, then I'll wait until the guys figure out what the 
correct fix is :)

Thanks,
Namhyung
