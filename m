Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2BQNMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:12:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52580 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2BQNMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:12:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120217115627.GA25601@elte.hu>
References: <20120212111914.GC21493@elte.hu>
	<1329178356-16645-1-git-send-email-kjwinchester@gmail.com>
	<20120217115627.GA25601@elte.hu>
Date: Fri, 17 Feb 2012 09:12:01 -0400
Message-ID: <CAELBVzC=O3ViyGD4tKEdajr37WO7FfbM5OU_yjNSWn+8rES1ww@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2012 07:56, Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> I'm still wondering if I should I give the same treatment to:
>>
>> cpu_sibling_map
>> cpu_core_map
>> cpu_llc_id
>> cpu_number
>>
>
> Yeah, I'd definitely give them the same treatment.
>
> Would you like to update your series? I'd suggest you keep patch
> #1 in place, as it's already probably reasonably well tested.
>

Sure, I'll leave that patch as #1, and add an additional patch per
field.  It will take me a week or two to find the time to get it all
together, but I'll keep working away at it.

-- 
Kevin Winchester
