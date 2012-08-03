Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2HCWqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:46:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40858 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2HCWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:46:11 -0400
Message-ID: <501C54AF.4090001@gmail.com>
Date: Sat, 04 Aug 2012 08:46:07 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Chris Jones <chrisjones@spin.net.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: Gaming and the kernel
References: <501C4CCE.8020806@spin.net.au>
In-Reply-To: <501C4CCE.8020806@spin.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, had to send this again so it could go to the mailing list. I 
accidentally replied to you personally :\

On 04/08/12 08:12, Chris Jones wrote:
> There's a lot of attention at the moment focused toward Linux and the 
> future of gaming support on the platform. And it got me thinking, is 
> there any particular improvements that are planned to improve the 
> kernel from better support for gaming?
>
>
> Regards
>
Hi Chris,

The biggest problem I can see at the moment is supporting dual-GPU 
setups in unusual ways.

For example, NVIDIA Optimus uses an Intel Core i* processor and 
integrated Intel 3/4000 graphics,
but also has a NVIDIA GeForge GT *M graphics card. However, this card 
cannot be accessed
directly, and all instructions effectively pass through the Intel 
graphics system.

I'm not entirely sure how that works, but it's what I've managed to 
gather from some tinkering.
It's being worked on at the moment (RandR 1.(5? 6? 7?) and DMA-BUF 
PRIME) - Which is good,
since the majority of laptops that I have seen being sold in my area 
either use NVIDIA
Optimus or some other similar system if they cost under $1000 or so.

Until these are implemented, there is no way for the kernel to access 
the dedicated graphics
card on these systems. There is, however, a project (Bumblebee) that 
seems to be doing
a good job performance-wise, but doesn't support automatic switching to 
the dedicated
graphics card.



On another note, not kernel based, Wine has actually managed to run
Grand Theft Auto: San Andreas faster on Ubuntu 12.04 than the default 
Windows 7
installation on this laptop. Valve has also committed to developing 
games on Linux
(starting with Ubuntu) with frame rates that, so far, have been higher 
than on Windows.

I guess we'll just have to wait and see what happens. There are a couple 
of things (some
of which are major, but thankfully not impossible)
