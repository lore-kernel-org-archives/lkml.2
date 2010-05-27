Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab0E0X3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:29:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45074
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab0E0X3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:29:09 -0400
Date: Thu, 27 May 2010 16:29:19 -0700 (PDT)
Message-Id: <20100527.162919.115912825.davem@davemloft.net>
To: julia@diku.dk
Cc: jpr@f6fbb.org, linux-hams@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/11] drivers/net/hamradio: Eliminate a NULL pointer
 dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005271432450.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005271432450.5422@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 27 May 2010 14:33:00 +0200 (CEST)

> At the point of the print, dev is NULL.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
