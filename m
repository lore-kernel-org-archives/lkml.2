Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2AXUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:20:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41538 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab2AXUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:20:27 -0500
Date: Tue, 24 Jan 2012 15:19:06 -0500 (EST)
Message-Id: <20120124.151906.1600710663231922646.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: romieu@fr.zoreil.com, pavel@ucw.cz, alan@lxorguk.ukuu.org.uk,
        torne@google.com, nic_swsd@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Randomise invalid MAC addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327430853.2568.4.camel@bwh-desktop>
References: <20120124171546.GA32184@atrey.karlin.mff.cuni.cz>
	<20120124182826.GA24128@electric-eye.fr.zoreil.com>
	<1327430853.2568.4.camel@bwh-desktop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 12:19:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 24 Jan 2012 18:47:33 +0000

> None of the push-back from netdev is going to have any effect on the
> embedded system developers who are failing to program MAC addresses
> properly; it's only going to hurt those adventurous users.

The implementation of denying interface bringup until a valid MAC is
configured is actually helping these adventurous users if the embedded
guys (which in the Intel situation, was the case) put the hack into
userspace to set the MAC address before bringing the interface up.

And this is really the only solution I think is warranted.
