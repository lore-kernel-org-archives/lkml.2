Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab2HVIyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:54:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:59924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078Ab2HVIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="189743323"
Message-ID: <50349E45.3020502@intel.com>
Date: Wed, 22 Aug 2012 16:54:29 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <jbeulich@suse.com>
CC: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com> <503450C1.8070600@intel.com> <50349AB4020000780008A4B5@nat28.tlf.novell.com>
In-Reply-To: <50349AB4020000780008A4B5@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:39 PM, Jan Beulich wrote:

>>>> Alex Shi <alex.shi@intel.com> 08/22/12 5:24 AM >>>
>> On 08/20/2012 10:12 PM, Jan Beulich wrote:
>> I was thought you have 'Agreed' for xen part code. :)
> 
> I had agreed to it being done the right way, and I had pointed out the
> problem once. I can't say for sure that I looked at the most recent rev
> closely enough to spot the issue still being unfixed.
> 
>>> For one, while TLB_FLUSH_ALL gets passed as 'end' argument to
>>> flush_tlb_others(), the Xen code was made to check its 'start'
>>> parameter.
>>
>> Do you mean need the following change? --untested.
> 
> Yes. I'd question though whether for that special case it shouldn't be
> start _and_ end to get passed the special value.


Actually the special value is already there in old code.
so, what's your meaning of the question?

> 
> Jan
> 


