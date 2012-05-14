Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2ENVFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:05:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34001 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2ENVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:05:04 -0400
Subject: Re: [PATCH -next] net/codel: Add missing #include
 <linux/prefetch.h>
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eric Dumazet <edumazet@google.com>, Dave Taht <dave.taht@bufferbloat.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <1337024825-20130-1-git-send-email-geert@linux-m68k.org>
References: <1337024825-20130-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 May 2012 23:04:58 +0200
Message-ID: <1337029498.8512.624.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 21:47 +0200, Geert Uytterhoeven wrote:
> m68k allmodconfig:
> 
> net/sched/sch_codel.c: In function ‘dequeue’:
> net/sched/sch_codel.c:70: error: implicit declaration of function ‘prefetch’
> make[1]: *** [net/sched/sch_codel.o] Error 1
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

I plaid guilty

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks


