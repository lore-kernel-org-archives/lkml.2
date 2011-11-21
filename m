Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab1KUVpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:45:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41450 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab1KUVpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:45:40 -0500
Date: Mon, 21 Nov 2011 16:44:21 -0500 (EST)
Message-Id: <20111121.164421.2285321515989917691.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: jj@chaosbits.net, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wg@grandegger.com
Subject: Re: [PATCH] net, sja1000: Don't include version.h in peak_pci.c
 when not needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ECA1F13.4080204@pengutronix.de>
References: <alpine.LNX.2.00.1111202204480.17195@swampdragon.chaosbits.net>
	<4ECA1F13.4080204@pengutronix.de>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 21 Nov 2011 13:44:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Mon, 21 Nov 2011 10:51:15 +0100

> On 11/20/2011 10:07 PM, Jesper Juhl wrote:
>> It was pointed out by "make versioncheck" that we do not need to include
>> version.h in drivers/net/can/sja1000/peak_pci.c
>> This patch removes the unneeded include.
>> 
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Applied, thanks everyone.
