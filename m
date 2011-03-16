Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1CPUcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:32:35 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:53188 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1CPUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:32:28 -0400
Message-ID: <4D811E5A.7080201@free.fr>
Date: Wed, 16 Mar 2011 21:32:26 +0100
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110309 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
References: <4D80B7EE.40706@Free.fr>	 <20110316195210.GA14675@home.goodmis.org>  <4D8118F7.5060107@free.fr> <1300306954.16880.51.camel@gandalf.stny.rr.com>
In-Reply-To: <1300306954.16880.51.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/2011 21:22, Steven Rostedt wrote:
> On Wed, 2011-03-16 at 21:09 +0100, Eric Vlette wrote:
>> On 16/03/2011 20:52, Steven Rostedt wrote:
>>> On Wed, Mar 16, 2011 at 02:15:26PM +0100, Eric Valette wrote:
>>>> Hi,
>>>>
>>>> Trying to compile 2.6.38, I found the follwoing bug. Compiler barks...
>>>
>>> New compiler? (new binutils more likely)
>>
>> Maybe. I use debian unstable + experimental and upgrade packages almost
>> everyday...
>
> You probably have new binutils.
>
> What does "as --version" give you. Binutils 2.21... ?

Well I found the problem at work and I'm home now but since I use the 
same distrib and just updated, its probably the same.

as --version
GNU assembler (GNU Binutils for Debian) 2.21.0.20110302

So probably most debian user will soon or late have the problem.


> I think it was 2.21 that started giving problems.

Sound plausible.

>> But obviously the begin end is not symmetric as in other function.
>
> Right, there was a discussion before about this causing issues with new
> binutils, and I think Ingo or Thomas said that they had patches to fix
> these for x86. Which this looks like one.
>
> The old binutils never complained.

Anyway this show once again that the world like symetry and you better 
remember it ;-) (lock/unlock, malloc free, ...)

Probably a stable candidate for 2.6.38.1

--eric
