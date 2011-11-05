Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1KEAIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:08:04 -0400
Received: from outbound.icp-osb-irony-out8.iinet.net.au ([203.59.1.134]:13789
	"EHLO outbound.icp-osb-irony-out8.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab1KEAID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:08:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBADd+tE46B7JU/2dsb2JhbAAMOKdwhQ0BAQEEOEABEAsJBAEKCRYPCQMCAQIBRQYKAwEHAQG+JYkrBIgIhHmHG4VQjCM
X-IronPort-AV: E=Sophos;i="4.69,458,1315152000"; 
   d="scan'208";a="166138398"
Message-ID: <4EB47E49.7070303@iinet.net.au>
Date: Sat, 05 Nov 2011 08:07:37 +0800
From: hagar <hagar@iinet.net.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Joel Schopp <jschopp@austin.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Nathan Lynch <nathanl@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Fwd: Kernel Power management ?? turning off used devices that
 are in use.
References: <4EA67567.3020704@iinet.net.au> <4EB38A44.5030606@iinet.net.au> <4EB403C0.3040803@austin.ibm.com>
In-Reply-To: <4EB403C0.3040803@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 23:24, Joel Schopp wrote:
>
>> I need to be able to either switch off cpu hotpluging - or at least 
>> prevent hotplugging certain cpu's
>>
>> there should really be a mincpu's option or better a 
>> nohotplug="0,1,2,5,7,etc" option.
>>
>> It would appear that cpu1 is the default cpu for those interrupts - 
>> and they are not being transferred to cpu0 properly.
>>
> The proper way to fix this is to find why the interrupts are not being 
> transferred and fix that.  Forcing cpus to not be hotpluggable is just 
> hiding the problem.
>
But it does allow the computer to become usable.
At the moment it is extremely borderline.
So much so that I would rather a non smp kernel and run off one cpu.

I have difficulty keeping the network up.
I have to run a cron job every minute to check the network and restart 
it if necessary.
Watching an hour long streaming video is impossible without moving the 
usb mouse constantly.

I am even considering a change of OS due to this problem.
>> I have tried the kernel parameters noapic nosmp maxcpus acpi=off 
>> possible_cpus=2 etc - with no success
>>
>> I did find a flaw in "possible_cpus=0" - this prevents the kernel 
>> booting (no cpus available )
>> This option should be set to a minimum of 1
>>
> We allow users to shoot themselves in the foot if they do silly 
> things.  This is a design decision.
>
Quite amusing.
