Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1FLCAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 22:00:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1FLCAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 22:00:34 -0400
Date: Sat, 11 Jun 2011 18:59:20 -0700 (PDT)
Message-Id: <20110611.185920.1234962334048234649.davem@davemloft.net>
To: jj@chaosbits.net
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sprenger@moving-bytes.de, info@bachem-it.com
Subject: Re: [PATCH] ISDN, hfcsusb: Don't leak in hfcsusb_ph_info()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1106111832270.23835@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106111832270.23835@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 18:59:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 11 Jun 2011 18:36:42 +0200 (CEST)

> We leak the memory allocated to 'phi' when the variable goes out of scope 
> in hfcsusb_ph_info().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper.
