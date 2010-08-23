Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0HWCMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:12:18 -0400
Received: from xenotime.net ([72.52.115.56]:52924 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752733Ab0HWCMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:12:16 -0400
Message-ID: <50730.173.50.240.230.1282529527.squirrel@xenotime.net>
In-Reply-To: <1282518018.1661.15.camel@bencharluo-laptop>
References: <1282518018.1661.15.camel@bencharluo-laptop>
Date: Sun, 22 Aug 2010 19:12:07 -0700 (PDT)
Subject: Re: ldd module param practice
From: rdunlap@xenotime.net
To: "runcoderen" <runcoderzhcn@gmail.com>
Cc: "Linux Kernel List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, August 22, 2010 4:00 pm, runcoderen wrote:
> hi all:
>
> #include <linux/init.h>
> #include <linux/module.h>
> #include <linux/moduleparam.h>
>
>
> MODULE_LICENSE("Dual BSD/GPL");
>
>
> static char *whom = "world"; static char howmany = 1;


What happens if you make 'howmany' an int instead of
a char?


> module_param(howmany, int, S_IRUGO); module_param(whom, charp, S_IRUGO);
>
> static int hello_init(void) {
> printk(KERN_ALERT "Hello, world\n"); return 0; }
>
>
> static void hello_exit(void) {
> printk(KERN_ALERT "Goodbye, cruel world\n"); }
>
>
> module_init(hello_init); module_exit(hello_exit);
>
> insmod hellop.ko howmany=10 whom="Mom"
>
> this code I want to printk "hello Mom" 10 times.
>
> but it doesn't work. so I modified static int howmany = 10, it doesn't
> work either. I don't know whether it's my wronging use?


