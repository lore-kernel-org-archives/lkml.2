Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1HLGLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:11:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58610 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1HLGLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:11:11 -0400
Date: Thu, 11 Aug 2011 23:10:06 -0700 (PDT)
Message-Id: <20110811.231006.537740938354501949.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-08-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110811182018.GF2566@tuxdriver.com>
References: <20110811182018.GF2566@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 23:10:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Aug 2011 14:20:19 -0400

> This is a little batch of patches intended for 3.1.
> 
> Included is a fix for a typo that incorrectly calibrated an ath9k phy,
> a fix for an skb leak in ath5k, a fix for a bus error on some Broadcom
> SoC using b43, a fix for a memory leak in wl1251, and another pair
> of calibration fixes for ath9k. A handful of device ID updates are
> included as well.
> 
> Please let me know if there are problems!

Pulled, thanks John.
