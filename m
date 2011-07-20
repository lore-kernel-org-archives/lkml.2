Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1GTQRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:17:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1GTQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:17:33 -0400
Date: Wed, 20 Jul 2011 09:17:29 -0700 (PDT)
Message-Id: <20110720.091729.2282261659766303321.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: udknight@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch]drivers:net:Kconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311163819.2338.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110720120500.GA3280@udknight.homenetwork>
	<1311163819.2338.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 20 Jul 2011 09:17:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 20 Jul 2011 14:10:19 +0200

> Here I have a (running) tg3 adapter, but
> 
> $ zgrep BROADCOM /proc/config.gz
> # CONFIG_BROADCOM_PHY is not set
> 
> Could you elaborate ?

Most of the PHY variants are handled entirely with code inside of the
tg3 driver, whereas some other tg3 PHY variants are handled by
external PHY layer drivers.
