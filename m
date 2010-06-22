Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab0FVOgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:36:16 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:46797 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab0FVOgN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:4:1>);
	Tue, 22 Jun 2010 10:36:13 -0400
Message-Id: <4C2075F90200003000087C46@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 Beta 
Date: Tue, 22 Jun 2010 08:36:09 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: "Greg KH" <greg@kroah.com>
Cc: <hjanssen@microsoft.com>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] Hyperv: Export the symbol that tracks hyperv
 features and recommendations
References: <4C1F80160200003000087BA8@sinclair.provo.novell.com>
 <20100621211319.GA25447@kroah.com>
In-Reply-To: <20100621211319.GA25447@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 6/21/2010 at  5:13 PM, in message <20100621211319.GA25447@kroah.com>, Greg
KH <greg@kroah.com> wrote: 
> On Mon, Jun 21, 2010 at 03:07:02PM -0600, Ky Srinivasan wrote:
>> 
>>  
>> From: K. Y. Srinivasan <ksrinivasan@novell.com>
>> Subject:  Export the symbol  for hyperv drivers to access hyperv
>> features and recommendations. This patch is needed by the hyperV clocksource 
> driver.
>> 
>> Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
>> 
>> Index: linux.trees.git/arch/x86/kernel/cpu/mshyperv.c
>> ===================================================================
>> --- linux.trees.git.orig/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 
> 10:14:02.000000000 -0600
>> +++ linux.trees.git/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 
> 14:12:11.000000000 -0600
>> @@ -18,6 +18,7 @@
>>  #include <asm/mshyperv.h>
>>  
>>  struct ms_hyperv_info ms_hyperv;
>> +EXPORT_SYMBOL(ms_hyperv);
> 
> EXPORT_SYMBOL_GPL()?  Didn't you have it that way in your previous
> patch?
I don't recall now. I agree with you that making it a  GPL export makes sense. 

Regards,

K. Y
> 
> thanks,
> 
> greg k-h


