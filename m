Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031360Ab2K3Sk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:40:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45358 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031078Ab2K3Sk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:40:27 -0500
Date: Fri, 30 Nov 2012 13:40:18 -0500 (EST)
Message-Id: <20121130.134018.1859855439413083920.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-11-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121130182459.GB2355@tuxdriver.com>
References: <20121130182459.GB2355@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 30 Nov 2012 13:25:00 -0500

> I have a couple of stragglers intended for 3.7...
> 
> The iwlwifi patch fixes a bug in CCK basic rate calculations.
> 
> The mac80211 patch removes an unnecessary function call that was
> generating a lot of log SPAM.

Pulled, thanks John.

I want to warn you ahead of time that these might not make it.
