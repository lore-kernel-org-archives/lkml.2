Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1JCHHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:07:08 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42873 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1JCHHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:07:05 -0400
Message-ID: <4E895EC3.3050800@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 12:35:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: rjw@sisk.pl, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Samsung Series 9 seems to require acpi=nonvs to resume properly
References: <1317329529.3151.10.camel@knife> <1317413360.2629.2.camel@knife>
In-Reply-To: <1317413360.2629.2.camel@knife>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2011 01:39 AM, Zan Lynx wrote:
> On Thu, 2011-09-29 at 14:51 -0600, Zan Lynx wrote:
>> After being annoyed that the latest Fedora 2.6.40 (aka 3.0 something)
>> kernels would not suspend/resume on my laptop I followed a Ubuntu forum
>> suggestion to use acpi=nonvs. This worked, or at least it is working
>> today with Fedora 15's 2.6.40.4-5.fc15.x86_64.
>>
>> The system is also booting via UEFI if that makes any difference.
>>
>> I understand that there is a no-NVS blacklist in the kernel. Should the
>> Samsung Series 9 be added to this list? Or could it be a different
>> suspend/resume problem entirely?
> 
> Please ignore this about nonvs. nonvs has nothing to do with the
> suspend/resume problem on this laptop.
> 
> Instead it seems to involve reboots, which is crazy. From a cold
> power-on start, suspend resume will always fail. But if the laptop is
> rebooted first, suspend and resume appear to work. What the heck? I have
> no clue how to debug this.

Could you provide any error logs you found? That could give us a clue as to
what is going wrong...

> 
> So now it appears that everything I ever tried to fix this only seemed
> to work because I rebooted after changing GRUB or module options.
> 


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
