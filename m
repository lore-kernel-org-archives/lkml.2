Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab0LZDll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 22:41:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab0LZDlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 22:41:40 -0500
Date: Sat, 25 Dec 2010 19:42:10 -0800 (PST)
Message-Id: <20101225.194210.104056075.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: soete.joel@scarlet.be, eric.dumazet@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6] sundance: Fix oopses with corrupted
 skb_shared_info
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101225151217.GA1994@del.dom.local>
References: <20101225121044.GA1841@del.dom.local>
	<4D15F6C9.50700@scarlet.be>
	<20101225151217.GA1994@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Sat, 25 Dec 2010 16:12:17 +0100

> [PATCH net-2.6] sundance: Fix oopses with corrupted skb_shared_info
> 
> Joel Soete reported oopses at the beginning of pppoe connections since
> v2.6.35. After debugging the bug was found in sundance skb allocation
> and dma mapping code, where skb_reserve() bytes aren't taken into
> account. This is an old bug, only uncovered by some change in 2.6.35.
> 
> Initial debugging patch by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Reported-by: Joel Soete <soete.joel@scarlet.be>
> Tested-by: Joel Soete <soete.joel@scarlet.be>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>

Applied, great work Jarek.

I was auditing ppp_generic.c hoping I'd find something, but
if I had that backtrace I wouldn't have bothered :-)
