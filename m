Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0H1CcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:32:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52425
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab0H1Cb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:31:58 -0400
Date: Fri, 27 Aug 2010 19:32:14 -0700 (PDT)
Message-Id: <20100827.193214.71098473.davem@davemloft.net>
To: julia@diku.dk
Cc: kernel-janitors@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4: Eliminate kstrdup memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282938463-26450-1-git-send-email-julia@diku.dk>
References: <1282938463-26450-1-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Fri, 27 Aug 2010 21:47:43 +0200

> The string clone is only used as a temporary copy of the argument val
> within the while loop, and so it should be freed before leaving the
> function.  The call to strsep, however, modifies clone, so a pointer to the
> front of the string is kept in saved_clone, to make it possible to free it.
> 
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks!
