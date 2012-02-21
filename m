Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2BUAYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:24:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50935 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2BUAYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:24:33 -0500
Date: Mon, 20 Feb 2012 19:23:24 -0500 (EST)
Message-Id: <20120220.192324.498901675497866305.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120220203740.GD6740@tuxdriver.com>
References: <20120220203740.GD6740@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Feb 2012 16:23:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 20 Feb 2012 15:37:40 -0500

> Here is another batch of fixes intended for 3.3.  Most of the fixes
> this time are for Bluetooth.

Pulled, but please read the bluetooth changes more carefully in the
future, there were a lot of coding style errors introduced this
time around.
