Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0JGXI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:08:29 -0400
Received: from asmtpout026.mac.com ([17.148.16.101]:50012 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0JGXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAE4BB6.7080509@windriver.com>
Date: Fri, 08 Oct 2010 03:07:58 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-id: <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com>
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
 <4CAE4BB6.7080509@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Oct 8, 2010, at 2:37 AM, Jason Wessel wrote:

> It would probably also be good to test if the debugger is working at all
> on your serial port.
> 
> Configure the debugger with:
> # echo ttyS2 > /sys/module/kgdboc/parameters/kgdboc
> kgdb: Registered I/O driver kgdboc.
> # echo g > /proc/sysrq-trigger
> SysRq : DEBUG
> 
> And now to exit debugger you must blindly and perfectly type
> $D#44+
> 
> Nothing will be echoed because at this stage the kernel serial polling
> driver would just be collecting characters.
> 
> After typing that the kernel should return back to the running state and
> print something like:
> +$OK#9a#

Cool, I tried all the commands that you suggested and it worked perfectly. I got the same outputs. 

So, if I understand correctly, I boot into the kernel without the kgbdwait option, and then manually launch the kgdb and then connect from Eclipse using gdb.

The system waits at the root login prompt. 

Just so that I can see some quick results, can you suggest which file I could set a break point into, and monitor the registers and variable states at this stage, i.e. immediately after the root login?

Best regards,

Elvis

