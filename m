Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0HRV20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:28:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60941
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571Ab0HRV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:28:23 -0400
Date: Wed, 18 Aug 2010 14:28:42 -0700 (PDT)
Message-Id: <20100818.142842.28795157.davem@davemloft.net>
To: julia@diku.dk
Cc: amit.salecha@qlogic.com, anirban.chakraborty@qlogic.com,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 16/16] drivers/net/qlcnic: Use available error codes
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1008161828520.19313@ask.diku.dk>
References: <Pine.LNX.4.64.1008161828520.19313@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Mon, 16 Aug 2010 18:29:13 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> The error code is stored in the variable err, but it is the variable ret
> that is returned instead.  So store the error code in ret.  Err is then
> useless.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
