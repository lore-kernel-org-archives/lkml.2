Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0ERU7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:59:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34617
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab0ERU7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:59:37 -0400
Date: Tue, 18 May 2010 13:59:45 -0700 (PDT)
Message-Id: <20100518.135945.180391159.davem@davemloft.net>
To: mpm@selenic.com
Cc: herbert@gondor.hengli.com.au, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274211235.11603.1205.camel@calx>
References: <20100518102701.GA7293@gondor.apana.org.au>
	<20100518.122512.73694279.davem@davemloft.net>
	<1274211235.11603.1205.camel@calx>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Tue, 18 May 2010 14:33:55 -0500

> SLOB honors ARCH_KMALLOC_MINALIGN. If your arch has alignment
> requirements, I recommend you set it.

I recommend that the alignment provided by the allocator is not
determined by which allocator I happen to have enabled.

The values and ifdef'ery should be identical in all of our
allocators.
