Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2GFR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:58:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:57484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2GFR6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:58:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174237836"
Message-ID: <4FF72733.8000007@linux.intel.com>
Date: Fri, 06 Jul 2012 10:58:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
References: <1341583705.4655.18.camel@amber.site>  <4FF71F1C.4040608@xenotime.net> <1341597439.4655.23.camel@amber.site>
In-Reply-To: <1341597439.4655.23.camel@amber.site>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/2012 10:57 AM, Jean Delvare wrote:
> Hi Randy,
> 
> Le vendredi 06 juillet 2012 à 10:23 -0700, Randy Dunlap a écrit :
>> On 07/06/2012 07:08 AM, Jean Delvare wrote:
>>
>>> This feature has been around for over 5 years now, so I presume it is
>>> no longer considered experimental.
>>>
>>> Signed-off-by: Jean Delvare <jdelvare@suse.de>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>>> Cc: Andi Kleen <andi@firstfloor.org>
>>> ---
>>> Or is there any reason to still consider this an experimental feature?
>>
>>
>> I doubt it, but if it is still experimental, it should also have
>> 	depends on EXPERIMENTAL
> 
> Agreed.
> 
>> and then it would be nice if kconfig (the software) would add the
>>   " (EXPERIMENTAL)" tag when it sees such a dependency.
> 
> Oh yeah, I've been dreaming of this for years now but never found the
> time to actually look into implementing it. Not sure if I would actually
> be able to anyway, as it will probably require some Kconfig magic beyond
> my knowledge.

I rather just retire the whole concept of "Experimental".

it's really utterly meaningless in practice anyway.

