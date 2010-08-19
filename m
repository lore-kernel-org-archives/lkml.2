Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab0HSF3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:29:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35309
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0HSF3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:29:06 -0400
Date: Wed, 18 Aug 2010 22:29:25 -0700 (PDT)
Message-Id: <20100818.222925.233689776.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: 64-bit ppc rwsem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282195403.22370.296.camel@pasglop>
References: <1282107803.22370.173.camel@pasglop>
	<20100817.222818.193699062.davem@davemloft.net>
	<1282195403.22370.296.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 19 Aug 2010 15:23:23 +1000

> Similar here, but using atomic_long_t instead so it works for 32-bit too
> for me. I suppose we could make that part common indeed.
> 
> What about asm-generic/rwsem-atomic.h  or rwsem-cmpxchg.h ?

Using rwsem-cmpxchg.h sounds best I guess.
