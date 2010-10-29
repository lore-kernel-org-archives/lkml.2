Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab0J2H3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 03:29:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64022 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab0J2H24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 03:28:56 -0400
Message-ID: <4CCA773F.6000809@kernel.org>
Date: Fri, 29 Oct 2010 00:26:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86: Disable x2apic if nox2apic is specified
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>	 <1287882149-29275-16-git-send-email-yinghai@kernel.org>	 <alpine.LFD.2.00.1010241204470.2466@localhost6.localdomain6>	 <4CC4AEAB.4030505@kernel.org>	 <1288029002.2675.22.camel@sbsiddha-MOBL3.sc.intel.com>	 <4CC7C64A.4070809@kernel.org> <1288331608.2717.14.camel@sbsiddha-MOBL3>
In-Reply-To: <1288331608.2717.14.camel@sbsiddha-MOBL3>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 10:53 PM, Suresh Siddha wrote:
> On Tue, 2010-10-26 at 23:27 -0700, Yinghai Lu wrote:
>> For
>> 1. x2apic preenabled system
>> 2. first kernel have x2apic enabled, and try to kexec second kernel with "nox2apic"
>>
>> Will put back cpu with apic id < 255 into xapic mode, instead of panic.
>>
>> -v2: use x2apic_disabled instead of nox2apic, Suggested by Thomas
>>      update x2apic_supported with x2apic_disabled, Suggested by Thomas
>>
>> -v3: add checking for boot cpu apic id > 255. in that case will just panic
>>      --- pointed out by Suresh.
>>
> 
> Can we please hold off in merging this patch for a bit? There are some
> subtleties in going back to xapic when the platform/cpu's are in x2apic
> mode. I will check and get back to you on this after KS.

sure. take you time.

	Yinghai
