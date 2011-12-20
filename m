Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1LTTNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:13:54 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42344 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1LTTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:13:49 -0500
Date: Tue, 20 Dec 2011 14:09:42 -0500 (EST)
Message-Id: <20111220.140942.650965480515835433.davem@davemloft.net>
To: gerlando.falauto@keymile.com
Cc: micha@neli.hopto.org, holger.brunck@keymile.com, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: have ipconfig not wait if no dev is available
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324371484-24082-1-git-send-email-gerlando.falauto@keymile.com>
References: <1324371484-24082-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Dec 2011 11:09:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerlando Falauto <gerlando.falauto@keymile.com>
Date: Tue, 20 Dec 2011 09:58:04 +0100

> previous commit 3fb72f1e6e6165c5f495e8dc11c5bbd14c73385c
> makes IP-Config wait for carrier on at least one network device.
> 
> Before waiting (predefined value 120s), check that at least one device
> was successfully brought up. Otherwise (e.g. buggy bootloader
> which does not set the MAC address) there is no point in waiting
> for carrier.
> 
> Cc: Micha Nelissen <micha@neli.hopto.org>
> Cc: Holger Brunck <holger.brunck@keymile.com>
> Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>

Applied, thanks.
