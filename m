Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2GYLCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:02:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:46033 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2GYLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:02:44 -0400
Message-ID: <500FD24B.4040703@parallels.com>
Date: Wed, 25 Jul 2012 15:02:35 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com>	<500E4960.8040307@parallels.com> <500E5951.5020900@amd.com>	<500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com>	<500E8280.6050905@parallels.com> <500E9664.9030306@amd.com> <20120724134405.7a42b5bd@pyramind.ukuu.org.uk> <500FCB02.2080603@parallels.com> <500FD158.2070503@amd.com>
In-Reply-To: <500FD158.2070503@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 02:58 PM, Andre Przywara wrote:
> On 07/25/2012 12:31 PM, Vladimir Davydov wrote:
>> On 07/24/2012 04:44 PM, Alan Cox wrote:
>>>> This approach does not need any kernel support (except for the
>>>> /proc/cpuinfo filtering). Does this address the issues you have?
>>> You can do the /proc/cpuinfo filtering in user space too
>>>
>> How?
> I wanted to write the same reply yesterday, but followed the hint in
> Alan's previous mail:
> # mount --bind /dev/shm/faked_cpuinfo /somepath/proc/cpuinfo
>
> I checked it, it works even with chroots and is not visible from within.

If CPUs go online/offline?

>
> Regards,
> Andre.
>

