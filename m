Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0EaHbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:31:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0EaHbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:31:21 -0400
Date: Mon, 31 May 2010 00:31:30 -0700 (PDT)
Message-Id: <20100531.003130.28788082.davem@davemloft.net>
To: julia@diku.dk
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 26/27] drivers/isdn: Use memdup_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005221026230.13021@ask.diku.dk>
References: <Pine.LNX.4.64.1005221026230.13021@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 22 May 2010 10:26:42 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Use memdup_user when user data is immediately copied into the
> allocated region.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
