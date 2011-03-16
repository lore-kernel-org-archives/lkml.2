Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1CPURa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:17:30 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:40762 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1CPURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:17:25 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 16:17:24 EDT
Message-ID: <4D8118F7.5060107@free.fr>
Date: Wed, 16 Mar 2011 21:09:27 +0100
From: Eric Vlette <eric.valette@free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
References: <4D80B7EE.40706@Free.fr> <20110316195210.GA14675@home.goodmis.org>
In-Reply-To: <20110316195210.GA14675@home.goodmis.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/2011 20:52, Steven Rostedt wrote:
> On Wed, Mar 16, 2011 at 02:15:26PM +0100, Eric Valette wrote:
>> Hi,
>>
>> Trying to compile 2.6.38, I found the follwoing bug. Compiler barks...
> 
> New compiler? (new binutils more likely)

Maybe. I use debian unstable + experimental and upgrade packages almost
everyday...

>>
>> diff linux-2.6.38/arch/x86/kernel/entry_32.S
>> linux-2.6.38/arch/x86/kernel/entry_32.S~
>> 1416c1416
>> < END(async_page_fault)
>> ---
>>> END(apf_page_fault)

But obviously the begin end is not symmetric as in other function.

>>
> 
> Ingo and Thomas,
> 
> IIRC, you have patches to fix these, right?
> 
> Thanks,
> 
> -- Steve
> 

