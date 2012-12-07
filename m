Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424106Ab2LGDXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 22:23:36 -0500
Received: from plane.gmane.org ([80.91.229.3]:53564 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424079Ab2LGDXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 22:23:35 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: Re: 8250 UART doesn't work
Date: Fri, 7 Dec 2012 03:23:18 +0000 (UTC)
Message-ID: <slrnkc2o7b.2ck.narkewoody@zuhnb712.local.com>
References: <slrnkc0jqu.4ir.narkewoody@zuhnb712.local.com>
 <50C0E737.2000201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.37.26.98
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-06, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/05/2012 11:56 PM, Woody Wu wrote:
>> Hi, list
>>
>> Does anyone here familiar to the serial 8250 driver?
>>
>> I enabled two uart ports in my board definition, but the ports doesn't
>> appear after I loaded the kernel (3.4.19).  I discovered, it failed at
>> the UART port auto configuration stage, the exact function is
>> autoconfig(...) in drivers/tty/serial/8250.c.
>>
>
> Sounds like you're using some kind of buggy UART IP... sharing which one 
> might help people identify the problem, if they have seen it before.
>
> 	-hpa
>

The UART controller is EXAR ST16C554D.  It claims as a 16550
compatible controller. Each ST16C554D module contains 4 UART, each of
them can be selected via two chip select pad. I think the board
hardware, via a CPLD, make the chip selection transparent to the CPU, so
by a 5-bit address, CPU can addressing individual 8 16550 compatible
registers of each UART.

I am not one hundred  percent sure I understood right, but this is all I
can say.  You experts can also judge whether this kind of hardware setup
is normal in embedded multi-serial ports solutions.

Many thanks!

-- 
woody
I can't go back to yesterday - because I was a different person then.

