Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1B1UfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:35:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55600
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab1B1UfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:35:23 -0500
Date: Mon, 28 Feb 2011 12:36:00 -0800 (PST)
Message-Id: <20110228.123600.179929985.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net/fec: fix unterminated platform_device_id table
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298453326.25444.3.camel@mola>
References: <1298453244.25444.1.camel@mola>
	<1298453326.25444.3.camel@mola>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 23 Feb 2011 17:28:46 +0800

> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
