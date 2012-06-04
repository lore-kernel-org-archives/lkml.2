Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2FDIjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:39:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58329 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2FDIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:39:22 -0400
Message-ID: <4FCC63D1.7060200@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 12:59:21 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com> <4FC7AE15.9040807@xenotime.net>
In-Reply-To: <4FC7AE15.9040807@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12060321-5490-0000-0000-0000018777BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 11:14 PM, Randy Dunlap wrote:
> On 05/31/2012 01:01 AM, Raghavendra K T wrote:
>
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>
>> Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ
>>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
>> new file mode 100644
>> index 0000000..c79335a
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/hypercalls.txt
>> @@ -0,0 +1,46 @@
>> +KVM Hypercalls Documentation
>> +===========================
>> +The template for each hypercall is:
>> +1. Hypercall name, value.
>> +2. Architecture(s)
>> +3. Status (deprecated, obsolete, active)
>> +4. Purpose
>> +
>> +1. KVM_HC_VAPIC_POLL_IRQ
>> +------------------------
>> +Value: 1
>> +Architecture: x86
>
>
> No "Status", does that imply "Active" ?
>

Oh! It was unintentionally left out. will add that.

