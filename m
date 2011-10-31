Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1JaFvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 01:51:19 -0400
Received: from ozlabs.org ([203.10.76.45]:45406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1JaFvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 01:51:18 -0400
From: Michael Neuling <mikey@neuling.org>
To: Santosh Kumar <santoshkumar.a@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: powerpc 476, Little-endian, pte fault
In-reply-to: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
Comments: In-reply-to Santosh Kumar <santoshkumar.a@gmail.com>
   message dated "Mon, 31 Oct 2011 11:00:14 +0530."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Mon, 31 Oct 2011 16:51:16 +1100
Message-ID: <12144.1320040276@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linuxppc-dev list to the CC

> KERNEL: linux 2.6.39.4
> POWERPC: 476, little endian.
> 
> I am trying to get linux 2.6.39.4 up on PPC 476 i have done done
> Big-endian to little endian Changes in:

Can you explain what you are trying to do in more detail?  What does "i
have done Big-endian to little endian Changes" mean?

> 1) bitops header file.
> 2) while reading the device tree.
> 3) the PTE read/computed in head_32.S
> 4) added E bit in the TLB entries.
> 
> with all the above changes the kernel_init is done but and inited is
> mounted.

Can you post your patch?

Are you trying to boot the kernel in little endian or just run userspace
in little endian?  

> But while spawning init process the kernel continuously hits pte
> faults at address 0x100000fc and never comes out. Please let me know
> where i should be looking into.

Is this the very first userspace instruction?

Mikey

