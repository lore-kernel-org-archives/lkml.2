Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1K3VXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:23:06 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1K3VXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:23:04 -0500
Date: Wed, 30 Nov 2011 16:21:57 -0500 (EST)
Message-Id: <20111130.162157.1166144157202128144.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-11-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111130193907.GB2477@tuxdriver.com>
References: <20111130193907.GB2477@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 Nov 2011 13:22:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 30 Nov 2011 14:39:07 -0500

> There is an nl80211 fix for validating user input to prevent a buffer
> underrun, a mac80211 race fix to prevent a WARN_ON, a mac80211 fix to
> avoid trying to stop a single aggregation session twice, a mac80211 fix
> for a race condition that could cause a crash when an addBA response
> came late, the partial reversion of an ath9k change that broke wireless
> on Ferrari One laptops, and a fix for an rtlwifi deadlock.
> 
> Please let me know if there are problems!

Applied, thanks.
