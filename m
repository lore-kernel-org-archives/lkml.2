Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2FISXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 14:23:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61751 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2FISXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 14:23:41 -0400
MIME-Version: 1.0
In-Reply-To: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com>
References: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com>
Date: Sat, 9 Jun 2012 23:53:40 +0530
Message-ID: <CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com>
Subject: Re: Break point not hit while debugging linux kernel with kgdb
From: Anil Nair <anilcoll90@gmail.com>
To: prasannatsmkumar <prasannatsmkumar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prasanna,

On Mon, May 28, 2012 at 3:46 PM, prasannatsmkumar
<prasannatsmkumar@gmail.com> wrote:
> Hi,
>
> I tried to debug the linux kernel with kgdb (over serial port).

The Maintainers would never recommend the use of a debugger, it
results in poorly fixed patches.

> I have
> configured the host and target machines and I am able to connect, step
> in the kernel code. In gdb I gave "break usb_register_dev" and "break
> usb_deregister_dev" and continued the execution (continue in gdb).
> Once the desktop is up, I connected a USB device (first tried with USB
> keyboard). Break point was not hit. I tried some more functions and
> break points are never hit. What should I do for it? Am I missing
> something?

You have to use gdbserver for connecting target and host systems i
guess. You may find many tutorials about it on the internet.


-- 
Regards,
Anil Nair
