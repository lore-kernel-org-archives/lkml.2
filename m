Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab2C0HiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:38:09 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52606 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2C0HiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:38:06 -0400
Message-ID: <4F716E31.3000803@linux.vnet.ibm.com>
Date: Tue, 27 Mar 2012 13:07:21 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>
In-Reply-To: <4F707C5F.1000905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12032621-5140-0000-0000-000000F53F48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 07:55 PM, Avi Kivity wrote:
> On 03/21/2012 12:20 PM, Raghavendra K T wrote:
>> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
[...]
>>
>> This series provides a Xen implementation, but it should be
>> straightforward to add a KVM implementation as well.
>>
>
> Looks like a good baseline on which to build the KVM implementation.  We
> might need some handshake to prevent interference on the host side with
> the PLE code.
>

Avi, Thanks for reviewing. True, it is sort of equivalent to PLE on non 
PLE machine.

Ingo, Peter,
Can you please let us know if this series can be considered for next 
merge window?
OR do you still have some concerns that needs addressing.

I shall rebase patches to 3.3 and resend. (main difference would be 
UNINLINE_SPIN_UNLOCK and jump label changes to use 
static_key_true/false() usage instead of static_branch.)

Thanks,
Raghu

