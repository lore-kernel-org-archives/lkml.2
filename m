Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab0IIE3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 00:29:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50720
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab0IIE3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 00:29:24 -0400
Date: Wed, 08 Sep 2010 21:29:41 -0700 (PDT)
Message-Id: <20100908.212941.241936726.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: greg@kroah.com, simon@fire.lp0.eu, dbrownell@users.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cxacru: ignore cx82310_eth devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009082252.15865.linux@rainbow-software.org>
References: <201009052212.37015.linux@rainbow-software.org>
	<20100908.131227.28827971.davem@davemloft.net>
	<201009082252.15865.linux@rainbow-software.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 8 Sep 2010 22:52:12 +0200

> Ignore ADSL routers, which can have the same vendor and product IDs
> as ADSL modems but should be handled by the cx82310_eth driver.
> 
> This intentionally ignores device IDs that aren't currently handled
> by cx82310_eth. There may be other device IDs that perhaps shouldn't
> be claimed by cxacru.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Applied with some minor comment formatting fixes, thanks!
