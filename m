Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab0E0XaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:30:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45078
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab0E0XaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:30:06 -0400
Date: Thu, 27 May 2010 16:30:16 -0700 (PDT)
Message-Id: <20100527.163016.48525549.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/11] drivers/net: Eliminate a NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1005271433180.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005271433180.5422@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 27 May 2010 14:33:32 +0200 (CEST)

> At the point of the print, dev is NULL.
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
