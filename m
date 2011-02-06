Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1BFCId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 21:08:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53485
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab1BFCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 21:08:31 -0500
Date: Sat, 05 Feb 2011 18:09:07 -0800 (PST)
Message-Id: <20110205.180907.189701283.davem@davemloft.net>
To: jj@chaosbits.net
Cc: venza@brownhat.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sis900: Fix mem leak in sis900_rx error path
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1102052139150.12305@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102052139150.12305@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 5 Feb 2011 21:41:53 +0100 (CET)

> Fix memory leak in error path of sis900_rx(). If we don't do this we'll 
> leak the skb we dev_alloc_skb()'ed just a few lines above when the 
> variable goes out of scope.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper.
