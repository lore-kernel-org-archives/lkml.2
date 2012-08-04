Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2HDA0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:26:08 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:4520 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2HDA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:26:05 -0400
Message-ID: <501C6BDF.9090803@spin.net.au>
Date: Sat, 04 Aug 2012 10:25:03 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: Re: Gaming and the kernel
References: <501C4CCE.8020806@spin.net.au> <501C545C.40601@gmail.com>
In-Reply-To: <501C545C.40601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.248, required 4, AWL 0.25, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/12 08:44, Cruz Julian Bishop wrote:
> On 04/08/12 08:12, Chris Jones wrote:
>> There's a lot of attention at the moment focused toward Linux and the 
>> future of gaming support on the platform. And it got me thinking, is 
>> there any particular improvements that are planned to improve the 
>> kernel from better support for gaming?
>>
>>
>> Regards
>>
> Hi Chris,
>
> The biggest problem I can see at the moment is supporting dual-GPU 
> setups in unusual ways.
>
> For example, NVIDIA Optimus uses an Intel Core i* processor and 
> integrated Intel 3/4000 graphics,
> but also has a NVIDIA GeForge GT *M graphics card. However, this card 
> cannot be accessed
> directly, and all instructions effectively pass through the Intel 
> graphics system.
>
> I'm not entirely sure how that works, but it's what I've managed to 
> gather from some tinkering.
> It's being worked on at the moment (RandR 1.(5? 6? 7?) and DMA-BUF 
> PRIME) - Which is good,
> since the majority of laptops that I have seen being sold in my area 
> either use NVIDIA
> Optimus or some other similar system if they cost under $1000 or so.
>
> Until these are implemented, there is no way for the kernel to access 
> the dedicated graphics
> card on these systems. There is, however, a project (Bumblebee) that 
> seems to be doing
> a good job performance-wise, but doesn't support automatic switching 
> to the dedicated
> graphics card.
>
>
>
> On another note, not kernel based, Wine has actually managed to run
> Grand Theft Auto: San Andreas faster on Ubuntu 12.04 than the default 
> Windows 7
> installation on this laptop. Valve has also committed to developing 
> games on Linux
> (starting with Ubuntu) with frame rates that, so far, have been higher 
> than on Windows.
>
> I guess we'll just have to wait and see what happens. There are a 
> couple of things (some
> of which are major, but thankfully not impossible)

It just seems to me that Valve is pressing ahead with games for Linux 
and no doubt there will be another influx of games and companies to 
follow not far behind if Valve make it a running success. And good luck 
to them. But on the other hand, it seems that kernel development is not 
quite up to scratch yet when it comes to full support for hardware 
graphics. And bring drivers in to the mix. Albeit, I do understand that 
graphics drivers should be handled and worked on by AMD and NVIDIA etc.

It's hard to describe what I mean. Basically, to the outside world via 
media, it is presented as "Valve is taking gaming to Linux. Wow, Linux 
is now capable of gaming!" That's all fine and everything. But we need 
to ensure that the kernel and all other aspects of code under our 
control is up to the task of handling a massive dump of games for Linux. 
Otherwise, it's going to backfire on us and Linux overall. It's moving 
very quickly.


Regards

-- 
         Chris Jones @ kernel.devproject@gmail.com
also on oracle.kerneldev@gmail.com and netbsd.kerneldev@gmail.com

Ubuntu 12.04 (PC)|Android (Smartphone)|Windows 7 (Laptop)|Windows XP (Gaming)
Linux kernel developer|Solaris kernel developer|BSD kernel developer|Lead Developer of SDL|Lead Developer of Nest Linux|Gamer and Emulator nut|Web Services|Digital Imaging Services
Controllers: Rapier V2 Gaming mouse|Logitech Precision|PS3 controller|XB360 controller|Logitech Attack 3 j/stick
Emulators: Fusion|Gens|ZSNES|Project64|PCSX-R|Stella|WinVICE|WinUAE|DOSBox

