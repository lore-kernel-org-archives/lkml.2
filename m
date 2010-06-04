Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab0FDXM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 19:12:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35032
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395Ab0FDXM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 19:12:57 -0400
Date: Fri, 04 Jun 2010 16:13:06 -0700 (PDT)
Message-Id: <20100604.161306.102569610.davem@davemloft.net>
To: julia@diku.dk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 21/27] drivers/ide: Use memdup_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005221024470.13021@ask.diku.dk>
References: <Pine.LNX.4.64.1005221024470.13021@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 22 May 2010 10:25:03 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Use memdup_user when user data is immediately copied into the
> allocated region.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, t hanks Julia.
