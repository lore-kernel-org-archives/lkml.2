Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2BGCDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:03:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34676 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2BGCDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:03:16 -0500
MIME-Version: 1.0
In-Reply-To: <4F308243.8030003@zytor.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<4F306FAF.7020500@cavium.com>
	<4F307D45.1050404@zytor.com>
	<4F307FB3.4030700@gmail.com>
	<4F308243.8030003@zytor.com>
Date: Mon, 6 Feb 2012 18:03:15 -0800
Message-ID: <CABeCy1bvtDo5sGRKC0AwtifbRp0nsCRXvzbHy4ue3VZ0B8JLbg@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 5:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/06/2012 05:34 PM, David Daney wrote:
>>
>>
>> Well I don't know that part. The gist of my comment was to get rid of an
>> unneeded new config variable.
>>
>> If this works just as well for 32-bit, then by all means do it there too.
>>
>> In any event, I think you want the kernel to automatically do it if the
>> CPU is capable, and not have a manual config setting you have to fiddle
>> with.
>>
>
> If this is a transitional thing then it might justify it.
>

There is nothing specific to 64 bit here. Its just that I had only
tested this on 64 bit right now and wanted to get early feedback. So,
in the spirit of RFC, I sent this out as x86_64 only for the time
being. If and when this will be sent for inclusion, this will should
work on both 32 bit and 64 bit on x86. Though we will need a config
option to not add any run time overhead in generic code (and to not
have #ifdef CONFIG_X86 in kernel/).

Thanks,
Venki
