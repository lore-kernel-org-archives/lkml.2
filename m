Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1GLSpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:45:47 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10326 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1GLSpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:45:46 -0400
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Tue, 12 Jul 2011 19:43:25 +0100
Subject: RE: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE MSR
Thread-Topic: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE
 MSR
Thread-Index: AcxAwpqW4SiWzkhCSOGAwe/gigxyqgAAGpbA
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE162F4A7384A@GVW0676EXC.americas.hpqcorp.net>
References: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
	 <1310491776.12417.31.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4E1C90B4.4030604@zytor.com>
 <1310495765.12417.32.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1310495765.12417.32.camel@sbsiddha-MOBL3.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Suresh Siddha [mailto:suresh.b.siddha@intel.com]
>Sent: Tuesday, July 12, 2011 1:36 PM
>To: H. Peter Anvin
>Cc: Chumbalkar, Nagananda; x86@kernel.org; linux-kernel@vger.kernel.org;
>mingo@elte.hu; tglx@linutronix.de
>Subject: Re: [PATCH] x86, x2apic: Preserve high 32-bits of
>IA32_APIC_BASE MSR
>
>On Tue, 2011-07-12 at 11:21 -0700, H. Peter Anvin wrote:
>> On 07/12/2011 10:29 AM, Suresh Siddha wrote:
>> >
>> > yeah, I don't think it was intentional.
>> >
>> > Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
>> >
>>
>> This isn't 3.0 material, though (no manifest error), correct?
>
>Yep. Right Naga?

That's correct. No manifest errors. This patch can wait.

- naga -




