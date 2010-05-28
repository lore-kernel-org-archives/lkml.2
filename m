Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0E1Kkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:40:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59271
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756690Ab0E1Kkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:40:40 -0400
Date: Fri, 28 May 2010 03:40:48 -0700 (PDT)
Message-Id: <20100528.034048.35019513.davem@davemloft.net>
To: bryan.wu@canonical.com
Cc: afleming@gmail.com, s.hauer@pengutronix.de, gerg@uclinux.org,
       amit.kucheria@canonical.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdev/fec: fix ifconfig eth0 down hang issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1275037685-14555-1-git-send-email-bryan.wu@canonical.com>
References: <1275037685-14555-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 28 May 2010 17:08:05 +0800

> BugLink: http://bugs.launchpad.net/bugs/559065
> 
> In fec open/close function, we need to use phy_connect and phy_disconnect
> operation before we start/stop phy. Otherwise it will cause system hang.
> 
> Only call fec_enet_mii_probe() in open function, because the first open
> action will cause NULL pointer error.
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Applied, thanks.
