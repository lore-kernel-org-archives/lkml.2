Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2EEBJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 21:09:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:40217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2EEBJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 21:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149538800"
Message-ID: <4FA47DCD.8000801@intel.com>
Date: Sat, 05 May 2012 09:09:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, cl@gentwo.org, eric.dumazet@gmail.com,
        tglx@linutronix.de, avi@redhat.com, davem@davemloft.net,
        kaber@trash.net, a.p.zijlstra@chello.nl, ying.huang@intel.com,
        konrad.wilk@oracle.com, hpa@zytor.com, jeremy@goop.org
Subject: Re: [PATH v2 0/5] Code clean up for percpu_xxx serial functions
References: <1326470018-22342-1-git-send-email-alex.shi@intel.com> <20120504142926.a930ba90.akpm@linux-foundation.org>
In-Reply-To: <20120504142926.a930ba90.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 05:29 AM, Andrew Morton wrote:

> On Fri, 13 Jan 2012 23:53:33 +0800
> Alex Shi <alex.shi@intel.com> wrote:
> 
>> I am sorry for spelling mistaken on konrad's email address, so resend
>> for correct this. Please reply this resend email. 
>>
>> ---------------
>> Thanks for TJ's suggestion, I split the serial patch smaller for
>> potential bisection convenience.
>>
>> Compare to v1 patch, this v2 patches has separate function replace
>> patches and final dead code clean up patch. 
>>
>> The net, xen and x86 part code are independent. 
>>
>> After each part was accepted in kernel, the final(5th) clean up code
>> do the real clean up in next merge window. I will refresh the patch
>> at that time. 
>>
>> Any further comments are appreciated!
>>
> 
> I'm still sitting on these patches.  The review was a bit inconclusive
> and confusing and everyone will have forgotten all about everything.  I
> think I'll drop them and ask for a resend, please.
> 
> Be sure to update the changelogs so that they address everything which
> was discussed last time - so we don't end up covering the same ground. 
> Please also Cc everyone who was involved in the discussion last time.
> 


Thanks for comments. I will try to refresh this upon mm tree next week.

> 


