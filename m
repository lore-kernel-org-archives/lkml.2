Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0GFFP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 01:15:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37168
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab0GFFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 01:15:55 -0400
Date: Mon, 05 Jul 2010 22:16:08 -0700 (PDT)
Message-Id: <20100705.221608.149821740.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net: correct valid flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1007060711320.30668@ask.diku.dk>
References: <Pine.LNX.4.64.1007051706530.15185@ask.diku.dk>
	<20100705.180349.112607097.davem@davemloft.net>
	<Pine.LNX.4.64.1007060711320.30668@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 6 Jul 2010 07:11:45 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Elsewhere in the "optimized" functions, the "2" constants are used.
> NV_TX_VALID and NV_TX2_VALID have the same value.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Since the two values are identical this doesn't fix a bug, so I've
applied this to net-next-2.6

Thanks!
