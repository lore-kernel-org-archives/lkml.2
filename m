Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1JTVsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:48:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52290 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1JTVsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:48:15 -0400
Date: Thu, 20 Oct 2011 17:48:07 -0400 (EDT)
Message-Id: <20111020.174807.1345631716931276111.davem@davemloft.net>
To: eibach@gdsys.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] net: Fix driver name for mdio-gpio.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318943051-22432-1-git-send-email-eibach@gdsys.de>
References: <1318943051-22432-1-git-send-email-eibach@gdsys.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 14:48:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Eibach <eibach@gdsys.de>
Date: Tue, 18 Oct 2011 15:04:11 +0200

> Since commit
> "7488876... dt/net: Eliminate users of of_platform_{,un}register_driver"
> there are two platform drivers named "mdio-gpio" registered.
> I renamed the of variant to "mdio-ofgpio".
> 
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>

Applied, thanks.
