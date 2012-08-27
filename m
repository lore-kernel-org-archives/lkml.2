Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2H0QCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:02:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48685 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2H0QCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:02:53 -0400
Message-ID: <503B99C7.3000503@linux.vnet.ibm.com>
Date: Mon, 27 Aug 2012 21:31:11 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
References: <20120827112503.10313.62594.stgit@localhost.localdomain> <20120827143619.GE27979@aftab.osrc.amd.com> <503B93D2.7090702@linux.vnet.ibm.com> <20120827154741.GI27979@aftab.osrc.amd.com>
In-Reply-To: <20120827154741.GI27979@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082716-5816-0000-0000-0000042C348E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 09:17 PM, Borislav Petkov wrote:
> On Mon, Aug 27, 2012 at 09:05:46PM +0530, Naveen N. Rao wrote:
>>>> +
>>>> +extern struct mce_boot_flags mce_boot_flags;
>>>
>>> Why do we need that extern thing?
>>
>> So that this is visible across mce.c and mce_intel.c?
>
> Ok. But if you move the struct to mce-internal.h and since both .c files
> include it, we shouldn't need that extern, right?

I'm not sure I understand. I think we still need it. This is not about 
the structure, but the variable itself. extern allows mce_boot_flags 
_variable_ accessible from mce_intel.c.


Thanks,
Naveen

>
> I think that'll be the most optimal placement for now.
>
> Thanks.
>

