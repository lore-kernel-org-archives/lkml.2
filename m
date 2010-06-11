Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0FKE46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab0FKE44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:56:56 -0400
Message-ID: <4C11C1E1.2050300@redhat.com>
Date: Fri, 11 Jun 2010 07:56:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <20100610172736.GA9737@phenom.dumpdata.com> <201006101858.38491.pugs@lyon-about.com>
In-Reply-To: <201006101858.38491.pugs@lyon-about.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 04:58 AM, Tom Lyon wrote:
> On Thursday 10 June 2010 10:27:36 am Konrad Rzeszutek Wilk wrote:
>    
>>> +EXPORT_SYMBOL(uiommu_fdget);
>>>        
>> EXPORT_SYMBOL_GPL
>> .. snip
>>      
>>> +EXPORT_SYMBOL(uiommu_put);
>>>        
>> ditto.
>>
>>      
> Is there a definitive explanation somewhere of when to use each?
>    

Always use _GPL unless you have a defensible reason why you shouldn't.  
The kernel's license if GPL, exporting a symbol without GPL can be seen 
as adding an exception to the license.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

