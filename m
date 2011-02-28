Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1B1UWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:22:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43334
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157Ab1B1UWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:22:03 -0500
Date: Mon, 28 Feb 2011 12:22:40 -0800 (PST)
Message-Id: <20110228.122240.48503372.davem@davemloft.net>
To: yanok@emcraft.com
Cc: sfr@canb.auug.org.au, greg@kroah.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dnet: fix wrong use of platform_set_drvdata()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298319630-18159-1-git-send-email-yanok@emcraft.com>
References: <4D62C897.5020707@emcraft.com>
	<1298319630-18159-1-git-send-email-yanok@emcraft.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Yanok <yanok@emcraft.com>
Date: Mon, 21 Feb 2011 21:20:30 +0100

> platform_set_drvdata() was used with argument of incorrect type and
> could cause memory corruption. Moreover, because of not setting drvdata
> in the correct place not all resources were freed upon module unload.
> 
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>

Applied.
