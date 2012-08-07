Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2HGIt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:49:57 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42120 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2HGItz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:49:55 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
In-Reply-To: <CAFLxGvy_X0r4njVMdUe1jnGciZYmcQr6d_ZpqOkZzQGc72yW2g@mail.gmail.com>
References: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
	<CAFLxGvy_X0r4njVMdUe1jnGciZYmcQr6d_ZpqOkZzQGc72yW2g@mail.gmail.com>
Date: Tue, 7 Aug 2012 14:19:54 +0530
Message-ID: <CANYdXnr4B_EtvPcYXvqqgttK3w5y-+ABD-bdYEwAzbJRNnxqrg@mail.gmail.com>
Subject: Re: A question on serial driver
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,
   I am new to serial framework. Can you please elaborate on what you
mean by implementing a hangup ?
On Tue, Aug 7, 2012 at 2:06 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Tue, Aug 7, 2012 at 10:22 AM, Shashidhar Hiremath
> <shashidharh@vayavyalabs.com> wrote:
>> Hi,
>>  I have written a console driver where I also do the serial driver
>> registration and handling. The driver seems to work fine till the
>> login point(reads and writes). The driver for some reason does not
>> print the content  I type on console after login prompt. Any reason
>> why this might be happening ?
>
> login and getty do a lot of TTY black magic, maybe you forgot to implement
> something like hangup()...
> Use strace to find out what the login programs are doing.
>
> --
> Thanks,
> //richard



-- 
regards,
Shashidhar Hiremath
