Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0EYE6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 00:58:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51336
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab0EYE6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 00:58:14 -0400
Date: Mon, 24 May 2010 21:58:22 -0700 (PDT)
Message-Id: <20100524.215822.13254177.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, NeilJay@gmail.com
Subject: Re: linux-next: build warning in Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100525114614.fd61d822.sfr@canb.auug.org.au>
References: <20100525114614.fd61d822.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 25 May 2010 11:46:14 +1000

> Hi Dave,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/net/usb/asix.c: In function 'asix_rx_fixup':
> drivers/net/usb/asix.c:325: warning: cast from pointer to integer of different size
> drivers/net/usb/asix.c:354: warning: cast from pointer to integer of different size
> 
> Introduced by commit 3f78d1f210ff89af77f042ab7f4a8fee39feb1c9
> ("drivers/net/usb/asix.c: Fix unaligned accesses").  This commit casts
> skb->data to u32.

Thanks I'll look into this.
