Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1AFXKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:10:48 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18928 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1AFXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:10:47 -0500
Date: Fri, 7 Jan 2011 00:10:46 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Sung-Uk Park <nothing@zpsys.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel oops !!! Help !!!
In-Reply-To: <34A653E1985643A197A7A15CF61572C8@sungukpark>
Message-ID: <alpine.LNX.2.00.1101070008200.13988@swampdragon.chaosbits.net>
References: <34A653E1985643A197A7A15CF61572C8@sungukpark>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1832088226-1294355446=:13988"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1832088226-1294355446=:13988
Content-Type: TEXT/PLAIN; charset=ks_c_5601-1987
Content-Transfer-Encoding: 8BIT

On Tue, 28 Dec 2010, Sung-Uk Park wrote:

> Hi there...
>  
> I got kernel oops please anybody help me~~~~
>  
> Dump message :
>  
> CPU 0 Unable to handle kernel paging request at virtual address 00000084,
> epc == 8000cb68, ra == 80001624
> Kernel unaligned instruction access[#1]:
> Cpu 0
> $ 0   : 00000000 1000ff00 b4b43427 18800010
> $ 4   : c3645514 8000a210 00000000 801ce4a0
> $ 8   : 1000ff00 86ff20e8 00000023 2aaf8000
> $12   : 00000022 92190000 8053b5e4 00000010
> $16   : 86ff20e8 dbfe7cce 80540000 0000001d
> $20   : 00000000 0000006d 00030000 801d0000
> $24   : 00000008 00000001                  
> $28   : 86ff2000 86ff20c0 000005a8 80001624
> Hi    : 00000095
> Lo    : e9e7e000
> epc   : 8000a210 do_ade+0x40/0x310     Not tainted
> ra    : 80001624 _ret_from_irq+0x0/0x10
> Status: 1000ff02    KERNEL EXL 
> Cause : 18800010
> BadVA : b4b4373b
> PrId  : 0001906c
> Modules linked in: rtdrv zpdrv rtk rtcore
> Process B1He?‡&QB½P±Ô´† #pÛþ|? (pid: 411041808, threadinfo=86ff2000,
> task=86ff20e8)
> Stack : cb433090 a750b81e d66b2c4f 704a712a b6dae55a 5c67eb64 86ff21c0
> dbfe7cce
>         80001624 58ef86ef 7a8f6d31 ff1be7c0 b8bc6a6b b16d3d75 f8775180
> e5c27d9f
>         00000000 1000ff00 b4b43427 18800010 c3645514 8000a210 00000000
> 801ce4a0
>         1000ff00 86ff21c0 00000023 2aaf8000 00000022 92190000 8053b5e4
> 00000010
>         86ff21c0 dbfe7cce 80540000 0000001d 00000000 0000006d 00030000
> 801d0000
>         ...
> Call Trace:
> [<8000a210>] do_ade+0x40/0x310
>  
> 
> Code: 00000000  8f820000  8e0300a8 <8c440314> 3c028000  00621824  30840001
> 24a20004  1080009b 
> Kernel panic - not syncing: Fatal exception in interrupt
>  Machine Restart ...
> ..
> 
> 
>  
> I am using MIPS CPU with linux kernel 2.6.19.
> What is the problem?
> Need more informations?
>  

Perhaps you could tell us what you were doing when you hit this oops.
Can you reproduce it? If you can, then a dump from a kernel with more 
debug info enabled would probably help.
Does it happen with a recent kernel like 2.6.37? (2.6.19 really is in the 
stone age by now).

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1832088226-1294355446=:13988--
