Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2FDIWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:22:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42833 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2FDIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:22:43 -0400
Message-ID: <4FCC700F.8020609@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 13:51:35 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, KVM <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com> <4FC7AE6C.9050106@zytor.com> <4FCC32F6.1010101@landley.net>
In-Reply-To: <4FCC32F6.1010101@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12060408-9574-0000-0000-0000030931C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 09:30 AM, Rob Landley wrote:
> On 05/31/2012 12:46 PM, H. Peter Anvin wrote:
>> On 05/31/2012 01:01 AM, Raghavendra K T wrote:
>>> +
>>> +TODO:
>>> +1. more information on input and output needed?
>>> +2. Add more detail to purpose of hypercalls.
>>>
>>
>> 1. definitely, including the hypercall ABI.
>>
>> 	-hpa
>>
>
> I was wondering about that. It looks like
> Documentation/virtual/kvm/api.txt might cover some of that already in
> section 5, but it doesn't look complete...
>
> Also, could I get a 00-INDEX file for this directory explaining what
> these individual files are? I think "api.txt" is supposed to be
> host-side API for controlling a guest VM (from userspace via ioctls,
> looks like),

api.txt has  plenty of information apart from  features which are 
related to guest side api (generally  controls / knows PV features 
available, that may also involve host query of guest cpuid).
and capability (of) related to host.

  and hypercalls.txt is guest-side API for poking the host.

hypercall can be used to take some actions (as needed by guest / 
exchange information)


> How someone would write host-side code that _responds_ to a hypercall, I
> have no idea.  (It goes in the host kernel?)
>
> Rob
>

