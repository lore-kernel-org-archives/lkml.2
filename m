Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1CPUxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:53:38 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:30917 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1CPUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:53:31 -0400
Message-ID: <4D812349.1050501@free.fr>
Date: Wed, 16 Mar 2011 21:53:29 +0100
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110309 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
References: <4D80B7EE.40706@Free.fr>	 <20110316195210.GA14675@home.goodmis.org>  <4D8118F7.5060107@free.fr>	 <1300306954.16880.51.camel@gandalf.stny.rr.com>  <4D811E5A.7080201@free.fr> <1300308282.16880.57.camel@gandalf.stny.rr.com>
In-Reply-To: <1300308282.16880.57.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/2011 21:44, Steven Rostedt wrote:
> On Wed, 2011-03-16 at 21:32 +0100, Eric Valette wrote:
>
>
>>> The old binutils never complained.
>>
>> Anyway this show once again that the world like symetry and you better
>> remember it ;-) (lock/unlock, malloc free, ...)
>
> Right, but it should be a warning not an error. If it worked before, why
> not work now and just warn about it. This "BUG" existed forever in the
> kernel, and its in more than one place. Having the compiler crash on the
> first instance means you need to fix it and run the compiler again to
> find the next instance and so on.

Yes like any other name change in a .h file with incompatible function 
signature...

The exact error message is a complaint about the .size directive not 
being a "constant"...


> binutils made a fatal error in making this a bug and not an warning.
>
>>
>> Probably a stable candidate for 2.6.38.1
>
> Perhaps, but what about all older kernels. Now this version of binutils
> does not work for bisecting.

I guess its binutils git of the 2011/03/02

As far as I'm concerned I only found one occurence on one machine 
although I compiled tree 2.6.38 kernels for different machines.
because its under the CONFIG_KVM_GUEST flag

--eric


