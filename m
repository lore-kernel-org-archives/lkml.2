Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2GYLqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:46:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:56005 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab2GYLqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:46:43 -0400
Message-ID: <500FDC9E.3010504@parallels.com>
Date: Wed, 25 Jul 2012 15:46:38 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andre Przywara <andre.przywara@amd.com>, Borislav Petkov <bp@amd64.org>,
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
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com>	<500E4960.8040307@parallels.com> <500E5951.5020900@amd.com>	<500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com>	<500E8280.6050905@parallels.com> <500E9664.9030306@amd.com>	<20120724134405.7a42b5bd@pyramind.ukuu.org.uk> <500FCB02.2080603@parallels.com> <20120725123132.7a43399b@pyramind.ukuu.org.uk>
In-Reply-To: <20120725123132.7a43399b@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 03:31 PM, Alan Cox wrote:
> On Wed, 25 Jul 2012 14:31:30 +0400
> Vladimir Davydov<vdavydov@parallels.com>  wrote:
>
>> On 07/24/2012 04:44 PM, Alan Cox wrote:
>>>> This approach does not need any kernel support (except for the
>>>> /proc/cpuinfo filtering). Does this address the issues you have?
>>> You can do the /proc/cpuinfo filtering in user space too
>>>
>> How?
> bind mount your own normal file over the top or a FUSE file

In general, we've agreed that wiring CPUID masking into the kernel was 
not a good idea.

We will try to virtualize /proc/cpuinfo as well as other /proc stuff in 
mainstream.

Thank you for your time and feedback.
