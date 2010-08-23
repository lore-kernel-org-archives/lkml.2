Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0HWEj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 00:39:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53543
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab0HWEj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 00:39:28 -0400
Date: Sun, 22 Aug 2010 21:39:45 -0700 (PDT)
Message-Id: <20100822.213945.241455303.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] rwsem: Move powerpc atomic-long based
 implementation to asm-generic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282281295.22370.401.camel@pasglop>
References: <1282195403.22370.296.camel@pasglop>
	<20100818.222925.233689776.davem@davemloft.net>
	<1282281295.22370.401.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 20 Aug 2010 15:14:55 +1000

> Other architectures who support cmpxchg and atomic_long can
> use that directly.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: David S. Miller <davem@davemloft.net>

I'll move sparc64 over to this once it hits Linus's tree.
