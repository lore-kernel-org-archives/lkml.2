Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2K1S7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:59:52 -0500
Received: from trent.utfs.org ([94.185.90.103]:50511 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab2K1S7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:59:50 -0500
Date: Wed, 28 Nov 2012 10:59:35 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org
Subject: Re: 3.7-rc7: BUG: MAX_STACK_TRACE_ENTRIES too low!
In-Reply-To: <1354092082.3054.19.camel@ThinkPad-T5421.cn.ibm.com>
Message-ID: <alpine.DEB.2.01.1211281051000.7378@trent.utfs.org>
References: <alpine.DEB.2.01.1211271824120.7378@trent.utfs.org>  <alpine.DEB.2.01.1211271916160.7378@trent.utfs.org> <1354092082.3054.19.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 at 16:41, Li Zhong wrote:
> Would you please help to try the following fix? I don't have a powerpc32
> machine for test...

I've just applied this to 3.7-rc7 and booted the machine. I don't know how 
to trigger this bug, so it might take a while until it happens again - or 
not, now with your patch applied.

It happened only 2 times so far, after ~8h and after ~20h:

Nov  5 13:28:20 alice kernel: [    0.000000] Linux version 3.7.0-rc4 
Nov  5 21:00:26 alice kernel: [27148.965634] BUG: MAX_STACK_TRACE_ENTRIES too low!
Nov 26 21:53:43 alice kernel: [    0.000000] Linux version 3.7.0-rc7 
Nov 27 17:15:29 alice kernel: [69731.388717] BUG: MAX_STACK_TRACE_ENTRIES too low!

Thanks,
Christian.
-- 
BOFH excuse #86:

Runt packets
