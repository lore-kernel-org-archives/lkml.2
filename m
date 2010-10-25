Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab0JYSxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:53:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55868
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab0JYSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:53:08 -0400
Date: Mon, 25 Oct 2010 11:53:31 -0700 (PDT)
Message-Id: <20101025.115331.193708760.davem@davemloft.net>
To: sam@ravnborg.org
Cc: namhyung@gmail.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sparc32: fix build failure on CONFIG_SPARC_LEON
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101025161122.GA25358@merkur.ravnborg.org>
References: <1288021958-3130-3-git-send-email-namhyung@gmail.com>
	<20101025.090043.71110898.davem@davemloft.net>
	<20101025161122.GA25358@merkur.ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 25 Oct 2010 18:11:22 +0200

> On Mon, Oct 25, 2010 at 09:00:43AM -0700, David Miller wrote:
>> From: Namhyung Kim <namhyung@gmail.com>
>> Date: Tue, 26 Oct 2010 00:52:38 +0900
>> 
>> >   CC      arch/sparc/kernel/irq_32.o
>> > arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
>> > arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
>> 
>> I doubt SMP LEON chips even exist, so better to just anti-dep
>> this in arch/sparc/Kconfig
> 
> I have a nice eval board at my desk with a dual-core LEON4 processor.
> I only lack time to play with it...

Ok.  But whenever someone gets a time to play with it and
verify it works, we can sort out this build failure by
modifying the code as needed.

But for now I prefer the Kconfig SMP dependency fix.
