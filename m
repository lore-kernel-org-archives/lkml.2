Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab2FIStw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 14:49:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43763 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab2FIStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 14:49:50 -0400
Message-ID: <4FD39A7F.9020106@mvista.com>
Date: Sat, 09 Jun 2012 22:48:31 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anil Nair <anilcoll90@gmail.com>
CC: prasannatsmkumar <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Break point not hit while debugging linux kernel with kgdb
References: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com> <CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com>
In-Reply-To: <CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/09/2012 10:23 PM, Anil Nair wrote:

>> Hi,

>> I tried to debug the linux kernel with kgdb (over serial port).

> The Maintainers would never recommend the use of a debugger, it
> results in poorly fixed patches.

    Yeah, KGDB was accepted into kernel exactly for more "poorly fixed patches" 
to appear. :-)

>> I have
>> configured the host and target machines and I am able to connect, step
>> in the kernel code. In gdb I gave "break usb_register_dev" and "break
>> usb_deregister_dev" and continued the execution (continue in gdb).
>> Once the desktop is up, I connected a USB device (first tried with USB
>> keyboard). Break point was not hit. I tried some more functions and
>> break points are never hit. What should I do for it? Am I missing
>> something?

> You have to use gdbserver

    gdbserver is only good for debugging the applications.

WBR, Sergei
