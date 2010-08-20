Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0HTWup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:50:45 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42960 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0HTWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UCr4E61ugUe4+uRLQaLWYGThWkqgiOWzIQwl/9hU5Y301QYvyyavHRbmhJw+APVhxX
         tVz2h6odK4SXzPKx5FCSoVX4Fm6FWcuUYTOJI4oA2LAKFNnpicA2ES5M8VFR6UbXYeee
         8HpjF36fw4XDqJ7tfRbm3AG+4eIqyu3vqt9Zs=
Subject: Re: sys_init_module system call
From: runcoderen <runcoderzhcn@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100820153254.3a87be2f.randy.dunlap@oracle.com>
References: <20100818041333.GA14149@lixom.net>
	 <20100818171636.0625b668.akpm@linux-foundation.org>
	 <20100819032230.GA21980@lixom.net> <20100820010242.GA29588@lixom.net>
	 <20100820221323.GC8535@lixom.net>
	 <1282342684.1631.4.camel@bencharluo-laptop>
	 <20100820153254.3a87be2f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 06:50:37 +0800
Message-ID: <1282344637.1631.13.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Randy:
yes, it does!
Thanks a lot!
	runcoderen

在 2010-08-20五的 15:32 -0700，Randy Dunlap写道：
> On Sat, 21 Aug 2010 06:18:04 +0800 runcoderen wrote:
> 
> > hi all
> > I find sys_init_module system call in kernel/module.c file.
> > but it did not find any.
> > the source code version is linux-2.6.35
> > 
> > does the kernel have changed?
> > 
> > the book I am reading is LDD 3rd edition
> 
> You won't find a function in kernel/module.c that looks like it has
> the name "sys_init_module".  Instead, the function is defined by using
> a macro, and it looks like this:
> 
> /* This is where the real work happens */
> SYSCALL_DEFINE3(init_module, void __user *, umod,
> 		unsigned long, len, const char __user *, uargs)
> {
> 
> 
> 
> The use of SYSCALL_DEFINEx(func_name, args) is a fairly recent change
> (well, January, 2009) that may be the reason why you think that there
> has been a change.  See
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a94bc34768e463a93cb3751819709ab0ea80a01
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 

/****************************************
http://runcoderen.wordpress.com/
****************************************/

