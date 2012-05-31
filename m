Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab2EaS4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:56:11 -0400
Received: from david.siemens.de ([192.35.17.14]:27005 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2EaS4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:56:08 -0400
Message-ID: <4FC7BEB2.8000207@siemens.com>
Date: Thu, 31 May 2012 20:55:46 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com> <4FC7AE15.9040807@xenotime.net>
In-Reply-To: <4FC7AE15.9040807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-31 19:44, Randy Dunlap wrote:
> On 05/31/2012 01:01 AM, Raghavendra K T wrote:
> 
>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 
>>
>> Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ 
>>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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

It should actually state that this call is in use.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
