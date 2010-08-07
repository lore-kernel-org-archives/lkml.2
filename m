Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0HGBau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:30:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17436 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0HGBas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:30:48 -0400
Message-ID: <4C5CB71D.1040509@kernel.org>
Date: Fri, 06 Aug 2010 18:30:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tvrtko.ursulin@sophos.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Map the local apic when parsing the
 MP table.
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org>	<tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>	<4C5CA3E4.1080908@kernel.org> <4C5CA5AC.3060608@zytor.com> <m1d3tvtekq.fsf@fess.ebiederm.org> <4C5CB52A.9080102@zytor.com>
In-Reply-To: <4C5CB52A.9080102@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 06:21 PM, H. Peter Anvin wrote:
> On 08/06/2010 06:08 PM, Eric W. Biederman wrote:
>>>
>>> I'm not sure the above is decipherable.  Please provide an incremental
>>> patch with a more detailed description.
>>
>> YH was saying I overoptimized, and it looks like he is right,
>> although there are only one or two machines in existence that
>> are likely to be affected.
>>
>> Untested patch to remove the cleverness below.  It it boots all
>> is well.
>>
> 
> This makes sense to me.  Yinghai, do you have a system that is actually
> affected, and if so, could you test this patch?

no, i don't have those kind of system.

found it when i was preparing more smp_register_lapic_address patcheset.

I suggest we still keep !acpi_lapic checking, that should always right.

Yinghai


