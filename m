Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0EXRop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:44:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34536
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721Ab0EXRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:44:44 -0400
Date: Mon, 24 May 2010 10:44:50 -0700 (PDT)
Message-Id: <20100524.104450.178799105.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: ben@simtec.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       x0066660@ti.com, s-jan@ti.com
Subject: Re: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D6DF528@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A64@MORGANITE.micrel.com>
	<20100516.002607.84408834.davem@davemloft.net>
	<14385191E87B904DBD836449AA30269D6DF528@MORGANITE.micrel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Mon, 24 May 2010 10:28:40 -0700

> As the socket buffer is accepted by the lowest level network driver and
> reaches the end of its life, I think using one of its variables
> temporarily does not cause any harm.

The packet can be referenced by packet sniffers and other entities in
the kernel.
