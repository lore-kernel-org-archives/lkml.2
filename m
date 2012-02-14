Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2BNFXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:23:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63028 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2BNFXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:23:19 -0500
Message-ID: <4F39EFBB.2010301@gmail.com>
Date: Mon, 13 Feb 2012 22:23:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>, Joerg Roedel <joerg.roedel@amd.com>
CC: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
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
References: <1329184375-27911-1-git-send-email-acme@infradead.org> <4F39CBE0.6050806@gmail.com> <4F39D00D.2060206@gmail.com> <4F39ECDB.5090609@lge.com>
In-Reply-To: <4F39ECDB.5090609@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/12 10:10 PM, Namhyung Kim wrote:
>>
>
> It happened because I used old kernel version that isn't aware of the
> exclude_guest bit. So the check on attr->__reserved_1 in
> core.c::perf_copy_attr() failed and then ended up seeing EINVAL at
> perf_evsel__open().

comes back to 1aed2671738785e8f5aea663a6fda91aa7ef59b5 again. See

https://lkml.org/lkml/2012/2/8/234

>
> So I think it should be handled in the same way of handling
> sample_id_all bit in perf record and top if we want to set perf_guest to
> false by default. I'll send patches for them soon.
>
> Thanks,
> Namhyung

