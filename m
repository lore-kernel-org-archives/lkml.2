Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0G0OmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:42:19 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:52389 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab0G0OmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:42:18 -0400
Message-id: <4C4EF03D.2000307@acm.org>
Date: Tue, 27 Jul 2010 09:42:05 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9)
 Gecko/20100423 Thunderbird/3.0.4
MIME-version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Fix memleaking for add_smi when duplicating happen
References: <4C4E3575.3020203@kernel.org> <4C4E3F03.4030707@acm.org>
 <4C4E6363.7060705@kernel.org>
In-reply-to: <4C4E6363.7060705@kernel.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 11:41 PM, Yinghai Lu wrote:
> On 07/26/2010 07:05 PM, Corey Minyard wrote:
>    
>> Please run this through checkpatch, as it has coding style violations.
>>      
> yhlu@linux-siqj:~/xx/xx/kernel/tip/linux-2.6>  ./scripts/checkpatch.pl patches/ipmi_reg_size.patch
> total: 0 errors, 0 warnings, 105 lines checked
>
> patches/ipmi_reg_size.patch has no obvious style problems and is ready for submission.
> yhlu@linux-siqj:~/xx/xx/kernel/tip/linux-2.6>
>    
Sorry, you are right.

>    
>> Also, this patch appears to fix bugs in addition to adding the print.
>> Can we have a separate patch for that?
>>      
> in the comment log, i already mentioned that.
>
> will separate it to twol
>    
Ok, thanks

>    
>> I'm also not clear on the reason for this.  I believe all this
>> information is already available in /proc/ipmi/<if#>/params.  I don't
>> think there is a strong reason to print it to the log.
>>      
> then why there is printing for ACPI path and pci path?
>    
Well, I'm not sure on this.  You are right, it is printed for those 
paths and not for DMI or SPMI cases.  Printing too much information is 
not generally a good idea, but this may be useful.  I guess to make it 
consistent it would be best to add this.

-corey
