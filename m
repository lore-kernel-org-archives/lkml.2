Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1HBQgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:36:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:7841 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab1HBQg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="34324185"
Message-ID: <4E382798.1090505@linux.intel.com>
Date: Tue, 02 Aug 2011 09:36:40 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] pti: add missing CONFIG_PCI dependency
References: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com> <20110802081129.b84a7bc7.rdunlap@xenotime.net> <4E382329.8080307@linux.intel.com> <20110802162417.GA1101@suse.de>
In-Reply-To: <20110802162417.GA1101@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 09:24 AM, Greg KH wrote:
> On Tue, Aug 02, 2011 at 09:17:45AM -0700, J Freyensee wrote:
>> On 08/02/2011 08:11 AM, Randy Dunlap wrote:
>>> On Tue, 2 Aug 2011 10:08:34 +0200 Heiko Carstens wrote:
>>>
>>>> From: Heiko Carstens<heiko.carstens@de.ibm.com>
>>>>
>>>> allmodconfig compile fails on s390 because of the new PTI driver:
>>>>
>>>> drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
>>>> drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'
>>>>
>>>> Add a 'depends on PCI' statement so it doesn't get compiled.
>>>>
>>>> Cc: J Freyensee<james_p_freyensee@linux.intel.com>
>>>
>>
>> Greg, did you see the patch go your way?
>>
>> http://marc.info/?l=linux-kernel&m=131007615706260&w=2
>>
>> Should I res-submit this patch to you through the linux-next mailing list?
>
> I'll pick it up, it's in my "to-apply" queue now.

Thanks Greg.

There probably is one more pti patch that has not been applied as well. 
  Stephen Rothwell asked about drivers/misc patches a week ago and I 
responded about this additional patch I also sent:

http://marc.info/?l=linux-next&m=131016084730837&w=2

I apologize for the confusion.


>
> thanks,
>
> greg k-h


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
