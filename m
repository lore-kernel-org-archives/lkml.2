Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2I0C3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:29:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48637 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2I0C3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:29:42 -0400
Message-ID: <5063BA0C.50304@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 10:29:32 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, kjwinchester@gmail.com,
        ak@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de
Subject: Re: [PATCH] x86: remove the useless branch in c_start()
References: <1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com> <506279F8.10704@linux.vnet.ibm.com> <20120926130257.GH17345@aftab.osrc.amd.com>
In-Reply-To: <20120926130257.GH17345@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092702-2000-0000-0000-0000094310F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 09:02 PM, Borislav Petkov wrote:
> On Wed, Sep 26, 2012 at 11:43:52AM +0800, Michael Wang wrote:
>> On 09/19/2012 01:42 PM, Michael Wang wrote:
>>> Since 'cpu == -1' in cpumask_next() is legal, no need to handle '*pos == 0'
>>> specially.
>>>
>>> About the comments:
>>> 	/* just in case, cpu 0 is not the first */
>>> A test with a cpumask in which cpu 0 is not the first has been done, and it
>>> works well.
>>
>> Could I get some comments on this patch?
> 
> Looks ok to me:
> 
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Thanks.

Thanks for your review.

Regards,
Michael Wang
> 

