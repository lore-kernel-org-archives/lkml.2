Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab1JFGwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:52:12 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53020 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab1JFGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:52:10 -0400
Message-ID: <4E8D4FC6.1080204@linux.vnet.ibm.com>
Date: Thu, 06 Oct 2011 12:20:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        Tejun Heo <tj@kernel.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <20111002195023.GC31799@mtj.dyndns.org> <201110052226.58373.rjw@sisk.pl> <4E8CC8FA.2090100@linux.vnet.ibm.com> <201110060043.19583.rjw@sisk.pl>
In-Reply-To: <201110060043.19583.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11100521-3568-0000-0000-00000078E4C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 04:13 AM, Rafael J. Wysocki wrote:
> On Wednesday, October 05, 2011, Srivatsa S. Bhat wrote:
>> On 10/06/2011 01:56 AM, Rafael J. Wysocki wrote:
>>>
>>> OK, can you please repost the patch with Borislav's Acked-by and Tested-by
>>> and add some more Intel people to the CC list?
>>>
>>
>> Sure, I'll do that. Thank you.
>> But are we not going to consider a cleaner/correct solution such as the
>> one proposed here:
>> http://permalink.gmane.org/gmane.linux.kernel/1199494
>>
>> Well, honestly I don't mean to be stubborn, but somehow, knowing that
>> there are issues with my patch doesn't make me feel very comfortable
>> going with it, especially when there is another approach, which I
>> believe can fix the issue properly, without undesirable side-effects.
>>
>> I agree that the issues are mostly some corner cases, so if you want a
>> quick fix for now, I guess we can go with this patch and then later on
>> follow-up with a proper solution to this whole problem.
> 
> It ultimately is your call.  If you feel more comfortable with the
> alternative, just post that one instead.
> 
Cool! I am working on implementing that other solution. I'll post it as soon
as I am done writing and testing that patch.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

