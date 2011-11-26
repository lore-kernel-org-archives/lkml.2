Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1KZT6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 14:58:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39430 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1KZT6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 14:58:40 -0500
Date: Sat, 26 Nov 2011 14:57:28 -0500 (EST)
Message-Id: <20111126.145728.475483160422235867.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, s-jan@ti.com,
        ben@simtec.co.uk
Subject: Re: [PATCH 0/5] ks8851 MAC and eeprom updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321901880-12883-1-git-send-email-sboyd@codeaurora.org>
References: <1321901880-12883-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 11:57:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Mon, 21 Nov 2011 10:57:55 -0800

> I pulled this patch series off the netdev list[1] when the eeprom
> reading didn't work for my ks8851 and I wanted the mac address to be
> read out at boot. It all seems to work well, so I'm posting it here
> again, slightly cleaned up and simplified, for inclusion.
> 
> Overall it reduces the lines of code and properly supports eeprom
> reading; two things the previous implementation doesn't do.
> 
> This is based off of linux-next-20111025.
> 
> Thanks to Ben Dooks for doing the heavy lifting.
> 
> [1] http://article.gmane.org/gmane.linux.network/159708

I guess I'll apply this series to net-next, I hope the eeprom layer
maintainers don't mind.

Thanks.
