Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2GYOOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:14:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54936 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2GYOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:14:16 -0400
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com> <500E4960.8040307@parallels.com> <500E5951.5020900@amd.com> <500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com> <500E8280.6050905@parallels.com> <500F4463.9050702@zytor.com> <500F9903.1020208@parallels.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <500F9903.1020208@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 25 Jul 2012 07:13:46 -0700
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Borislav Petkov <bp@amd64.org>, Andre Przywara <andre.przywara@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <f743f40a-ca5a-42aa-8086-4d7d2224cf95@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the necessary infrastructure, yes.  Trap and emulate is montrivial work.

Vladimir Davydov <vdavydov@parallels.com> wrote:

>On 07/25/2012 04:57 AM, H. Peter Anvin wrote:
>> On 07/24/2012 04:09 AM, Vladimir Davydov wrote:
>>> We have not encountered this situation in our environments and I
>hope we
>>> won't :-)
>>>
>>> But look, these CPUID functions cover majority of CPU features,
>don't
>>> they? So, most of "normal" apps inside VM will survive migration.
>>> Perhaps, some low-level utils won't. I guess that's why there are no
>>> MSRs for other levels provided by vendors.
>>>
>> You will once Ivy Bridge becomes common.
>
>Ivy Bridge has CPUID faulting, which allows masking all CPUID 
>levels/functions.
>
>> 	-hpa
>>

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
