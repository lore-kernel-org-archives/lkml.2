Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2DYTPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:15:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53191 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab2DYTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:15:24 -0400
Date: Wed, 25 Apr 2012 15:14:13 -0400 (EDT)
Message-Id: <20120425.151413.147876040219098157.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-04-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120425180639.GA16900@tuxdriver.com>
References: <20120425180639.GA16900@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 12:14:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 25 Apr 2012 14:06:39 -0400

> This is a batch of fixes intended for 3.4.
> 
> The brcmsmac patch from Eldad Zack eliminates some log spam.
> The mac80211 patch from Eliad Peller fixes a WARNING when removing
> an interface.  The two patches from Gabor Juhos combine to address
> a regression with some bad tx power settings for an Atheros chip.
> Johannes Berg gives us a fix for some bad hardware initializtion in
> iwlwifi, which resulted in hardware lockups.  Larry Finger gives us
> a fix for an oops when unloading the rtlwifi modules.  Meenakshi
> Venkataraman fixes some firmware version values in iwlwifi that
> result in attempts to load firmware that does not exist in the wild.
> Stanislav Yakovlev fixes a race condition in the ipw2200 driver.
> Finally,  Stanislaw Gruszka provides an iwlwifi fix to avoid a NULL
> pointer access.

Pulled, thanks John.
