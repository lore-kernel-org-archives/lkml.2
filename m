Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab2JWFlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:41:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:49635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab2JWFlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:41:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,633,1344236400"; 
   d="scan'208";a="238856783"
Message-ID: <50862E02.6020002@intel.com>
Date: Tue, 23 Oct 2012 13:41:22 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>  <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com> <1350902138.2768.86.camel@twins>
In-Reply-To: <1350902138.2768.86.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 06:35 PM, Peter Zijlstra wrote:
> On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -160,8 +160,9 @@ enum perf_branch_sample_type {
>>         PERF_SAMPLE_BRANCH_ABORT        = 1U << 7, /* transaction aborts */
>>         PERF_SAMPLE_BRANCH_INTX         = 1U << 8, /* in transaction (flag) */
>>         PERF_SAMPLE_BRANCH_NOTX         = 1U << 9, /* not in transaction (flag) */
>> +       PERF_SAMPLE_BRANCH_CALL_STACK   = 1U << 10, /* call stack */
>>  
>> -       PERF_SAMPLE_BRANCH_MAX          = 1U << 10, /* non-ABI */
>> +       PERF_SAMPLE_BRANCH_MAX          = 1U << 11, /* non-ABI */
>>  }; 
> 
> You add an ABI sample type without mentioning it in your changelog.. I
> think I'll stop reading here.
> 
Ok, I will add the ABI change to the change log. Do you think we should hide this
branch sample type from user?

Regards
Yan, Zheng 
