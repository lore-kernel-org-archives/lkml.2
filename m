Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab0HEUsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:48:02 -0400
Received: from mail.atheros.com ([12.36.123.2]:49128 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877Ab0HEUr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:47:59 -0400
Date: Thu, 5 Aug 2010 13:47:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Julia Lawall <julia@diku.dk>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>,
        Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 33/42] drivers/net/wireless/ath/ath9k: Adjust confusing
 if indentation
Message-ID: <20100805204756.GA1738@tux>
References: <Pine.LNX.4.64.1008052226380.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052226380.31692@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 01:26:56PM -0700, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Outdent the code following the if.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
> 
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> if (p1[0].column == p2[0].column):
>   cocci.print_main("branch",p1)
>   cocci.print_secs("after",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

> ---
> This patch doesn't change the semantics of the code.  But it might not be
> what is intended.

Your patch is correct, it wast a tab goof, thanks for fixing this.

  Luis
