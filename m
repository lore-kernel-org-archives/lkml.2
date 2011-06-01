Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab1FASUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:20:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115Ab1FASUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:20:00 -0400
Message-ID: <4DE682C0.9060208@zytor.com>
Date: Wed, 01 Jun 2011 11:19:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some x86, asm cleanups
References: <1306873314-32523-1-git-send-email-bp@alien8.de>    <4DE59E9E.5030802@zytor.com> <820d76c11c182f41dcbc652926e27d94.squirrel@www.skyhub.de>
In-Reply-To: <820d76c11c182f41dcbc652926e27d94.squirrel@www.skyhub.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 11:14 AM, Borislav Petkov wrote:
>>
>> Any way you can try them out on the gas version from hell[TM], a.k.a.
>> 2.16?
> 
> I think by that you mean this guy:
> 
>  as --version
> GNU assembler 2.16.91.0.5 20051219 (SUSE Linux)
> Copyright 2005 Free Software Foundation, Inc.
> This program is free software; you may redistribute it under the terms of
> the GNU General Public License.  This program has absolutely no warranty.
> This assembler was configured for a target of `x86_64-suse-linux'.
> 
> at least this is one incarnation of it. I had to install SLES10 SP3
> with the unpatched binutils version in kvm to test. And yes, the kernel
> builds fine. Let me know if I should run some randconfigs, in addition.
> 
> Btw, I'm keeping the kvm image for future testing with the bat from hell :).
> 

I think 2.16.9x is really 2.17.

	-hpa
