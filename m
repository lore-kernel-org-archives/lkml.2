Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2KFX5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:57:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:32880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KFX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:57:53 -0500
Date: Tue, 06 Nov 2012 18:57:52 -0500 (EST)
Message-Id: <20121106.185752.1986400393399264104.davem@davemloft.net>
To: lee.jones@linaro.org
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121105103126.GB5220@gmail.com>
References: <20121104105332.GC27124@gmail.com>
	<20121104.123013.700345271120279281.davem@davemloft.net>
	<20121105103126.GB5220@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Mon, 5 Nov 2012 11:31:26 +0100

> Does something like look like a better solution?
> 
> Author: Lee Jones <lee.jones@linaro.org>
> Date:   Sat Nov 3 22:06:02 2012 +0100
> 
>     isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES

Yes, it looks good, please resubmit it formally.
