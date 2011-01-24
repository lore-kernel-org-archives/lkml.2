Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1AXSNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:13:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57201 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1AXSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WUCq7S0iSa02APuzE9xZNLlbPO9CQi3V7M9JPai4VEEar5OkA1+lrqbbPOcxBafSyv
         x5Hb43z1g/5vpSw2Ihk+B0K1N7lGFyCfzVo/9ZUIiJn0dHsj5kdhu6Mct+Y2pxaKBuoF
         0B22qesIJATPJjG0jFehJEOSi38dshFVKTh3U=
Subject: Re: acpi_button: random oops on boot
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: richard.coe@med.ge.com, jslaby@novell.com, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201101241403.21707.trenn@suse.de>
References: <1291477752.5096.27.camel@Tobias-Karnat>
	 <1291679699.6246.11.camel@Tobias-Karnat>
	 <20101207051521.GA16804@helgaas.com>  <201101241403.21707.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 19:13:06 +0100
Message-ID: <1295892786.3265.48.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 24.01.2011, 14:03 +0100 schrieb Thomas Renninger:
> Aren't there some memory corruption checkers which can
> additionally be enabled?
> 
> CONFIG_DEBUG_SLAB
> Say Y here to have the kernel do limited verification on memory
> allocation as well as poisoning memory on free to catch use of freed
> memory. This can make kmalloc/kfree-intensive workloads much slower.
> 
> CONFIG_DEBUG_VM
> Enable this to turn on extended checks in the virtual-memory system
> that may impact performance.
> 
> CONFIG_DEBUG_LIST
> Enable this to turn on extended checks in the linked-list
> walking routines.
> 
> CONFIG_DEBUG_PAGEALLOC
> Unmap pages from the kernel linear mapping after free_pages().
> This results in a large slowdown, but helps to find certain types
> of memory corruption.
> 
> Did I oversee one?
> 
> Not sure which is best, it should not hurt to turn on all
> (if possible) for a test.
> 
>     Thomas

I would like to help, but I don't have another pc here, which I could
connect over serial. And when it crashes on boot, there is never a call
trace to see.

I hope Rich is still interested in a solution as I am. The bad thing is
that the latest working version I had been running on that machine was
ancient 2.6.23. So this problem is a regression, which I would have
noticed earlier, if I had updated that machine more often.

It is not an hardware problem, I have edac enabled and I don't see any
errors. The only strange thing I get related to memory is an mtrr entry
of 64GB (I only have 6GB).

-Tobias

