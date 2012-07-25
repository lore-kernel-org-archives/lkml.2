Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2GYLB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:01:26 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:23972
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686Ab2GYLBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:01:25 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M7PQM7-01-3GU-02
X-M-MSG: 
Message-ID: <500FD158.2070503@amd.com>
Date: Wed, 25 Jul 2012 12:58:32 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
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
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com>	<500E4960.8040307@parallels.com> <500E5951.5020900@amd.com>	<500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com>	<500E8280.6050905@parallels.com> <500E9664.9030306@amd.com> <20120724134405.7a42b5bd@pyramind.ukuu.org.uk> <500FCB02.2080603@parallels.com>
In-Reply-To: <500FCB02.2080603@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 12:31 PM, Vladimir Davydov wrote:
> On 07/24/2012 04:44 PM, Alan Cox wrote:
>>> This approach does not need any kernel support (except for the
>>> /proc/cpuinfo filtering). Does this address the issues you have?
>> You can do the /proc/cpuinfo filtering in user space too
>>
>
> How?

I wanted to write the same reply yesterday, but followed the hint in 
Alan's previous mail:
# mount --bind /dev/shm/faked_cpuinfo /somepath/proc/cpuinfo

I checked it, it works even with chroots and is not visible from within.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

