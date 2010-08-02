Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0HBXEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:04:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47724
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727Ab0HBXEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:04:14 -0400
Date: Mon, 02 Aug 2010 16:04:33 -0700 (PDT)
Message-Id: <20100802.160433.42797035.davem@davemloft.net>
To: julia@diku.dk
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/sparc/mm: Use GFP_KERNEL
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1008011109260.21594@ask.diku.dk>
References: <Pine.LNX.4.64.1008011109260.21594@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 1 Aug 2010 11:09:44 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> GFP_ATOMIC is not needed here, as evidenced by the other two uses of
> GFP_KERNEL in the same function.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks Julia.
