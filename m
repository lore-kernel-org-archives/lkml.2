Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1AIXpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:45:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49581
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab1AIXpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:45:43 -0500
Date: Sun, 09 Jan 2011 15:46:15 -0800 (PST)
Message-Id: <20110109.154615.200375094.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, jpr@f6fbb.org, frible@teaser.fr,
        sailer@ife.ee.ethz.ch
Subject: Re: [PATCH] hamradio: Resolve memory leak due to missing firmware
 release in add_mcs()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1101062146430.13988@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101062146430.13988@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 6 Jan 2011 21:50:29 +0100 (CET)

> 
> Failure to release_firmware() in drivers/net/hamradio/yam.c::add_mcs() 
> causes memory leak.
> This patch should fix it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
