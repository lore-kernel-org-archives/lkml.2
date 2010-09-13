Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab0IMObG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:31:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51734 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0IMObF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=xb2LO2QBDCVE6Ct0YFsj6Qz2/QZEKrWyAFwtTfNPHuSc3TeWLLsh6fMtIdI4IcYKfV
         GXc9y+tUmjLQvIx+0dRhahUUgD9ADKGvzoQ5LQL8tg1+MmH8HvFaCfL71kLZhqcPgydS
         VmoBBV461FqCWkwVG0mS4R71aHsygjX6XComM=
MIME-Version: 1.0
In-Reply-To: <AANLkTiksacwuOwqJGZ0F3M1jhZ6Srr88wbfBQodOGOAt@mail.gmail.com>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
	<20100913121247.GA4003@sig21.net>
	<AANLkTiksacwuOwqJGZ0F3M1jhZ6Srr88wbfBQodOGOAt@mail.gmail.com>
Date: Mon, 13 Sep 2010 16:31:04 +0200
Message-ID: <AANLkTim4pJYMyRpb8SQddS_fiReQKKCvBCFrgEGUb+v+@mail.gmail.com>
Subject: Fwd: ARM target not boot after remap memory
From: Robin Theunis <robint91@gmail.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Johannes

I have compiled  the kernel with early printk on and debug_LL, It
still doesn't nothing after that line.

Robin

2010/9/13 Johannes Stezenbach <js@sig21.net>:
> On Mon, Sep 13, 2010 at 01:25:26PM +0200, Robin Theunis wrote:
>>
>> Uncompressing Linux... done, booting the kernel.
>> ---
>>
>> Here is stalls. With my jtag probe I can locate the problem.
>>
>> ---
>> > halt
>> target state: halted
>> target halted in ARM state due to debug-request, current mode: Supervisor
>> cpsr: 0x600000d3 pc: 0xc000af3c
>> MMU: enabled, D-Cache: enabled, I-Cache: enabled
>> >   arm disassemble 0xc000af3c
>> 0xc000af3c    0xeafffffe      B 0xc000af3c
>> ---
>>
>> This just loops at that address. Why does it that?
>
> Maybe it panicked but you can't see the message since
> you have not enabled EARLY_PRINTK.
>
> Since you have JTAG, you could also dump the printk
> buffer __log_buf to see the message.
>
>
> HTH
> Johannes
>
