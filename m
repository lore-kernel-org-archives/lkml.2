Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2GYG6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:58:17 -0400
Received: from relay.parallels.com ([195.214.232.42]:55386 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2GYG6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:58:16 -0400
Message-ID: <500F9903.1020208@parallels.com>
Date: Wed, 25 Jul 2012 10:58:11 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>, Andre Przywara <andre.przywara@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com> <500E4960.8040307@parallels.com> <500E5951.5020900@amd.com> <500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com> <500E8280.6050905@parallels.com> <500F4463.9050702@zytor.com>
In-Reply-To: <500F4463.9050702@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 04:57 AM, H. Peter Anvin wrote:
> On 07/24/2012 04:09 AM, Vladimir Davydov wrote:
>> We have not encountered this situation in our environments and I hope we
>> won't :-)
>>
>> But look, these CPUID functions cover majority of CPU features, don't
>> they? So, most of "normal" apps inside VM will survive migration.
>> Perhaps, some low-level utils won't. I guess that's why there are no
>> MSRs for other levels provided by vendors.
>>
> You will once Ivy Bridge becomes common.

Ivy Bridge has CPUID faulting, which allows masking all CPUID 
levels/functions.

> 	-hpa
>

