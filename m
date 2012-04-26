Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2DZQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:05:13 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47500 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab2DZQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:05:08 -0400
Message-ID: <4F997216.6080804@linux.vnet.ibm.com>
Date: Thu, 26 Apr 2012 21:34:38 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH RFC V6 5/5] Documentation/kvm : Add documentation on Hypercalls
 and features used for PV spinlock
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423100034.30893.81866.sendpatchset@codeblue.in.ibm.com> <4F997058.6070509@landley.net>
In-Reply-To: <4F997058.6070509@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12042616-5564-0000-0000-0000025EC8D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 09:27 PM, Rob Landley wrote:
> On 04/23/2012 05:00 AM, Raghavendra K T wrote:
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
> ...
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/hypercalls.txt
>> @@ -0,0 +1,59 @@
>> +KVM Hypercalls Documentation
>> +===========================
>> +Template for documentation is
>> +The documenenation for hypercalls should inlcude
>
> What does the line about templates mean/
>
> documenenation? inlcude?

I think I should correct some redundant statements here. The template is 
meant for current "structure / layout of hypercall documentation".

>
>> +1. Hypercall name, value.
>> +2. Architecture(s)
>> +3. status (deprecated, obsolete, active)
>> +4. Purpose
>> +
>> +
>> +1. KVM_HC_VAPIC_POLL_IRQ
>> +------------------------
>> +value: 1
>> +Architecture: x86
>> +Purpose:
>
> Purpose: none.
>

Will add this when I respin the patch soon

> Rob

Thanks for review.

