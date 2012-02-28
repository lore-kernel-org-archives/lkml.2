Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2B1CTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:19:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab2B1CTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:19:41 -0500
Date: Mon, 27 Feb 2012 21:18:30 -0500 (EST)
Message-Id: <20120227.211830.905259317987117782.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120227201507.GE26664@tuxdriver.com>
References: <20120227201507.GE26664@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 27 Feb 2012 18:18:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 27 Feb 2012 15:15:07 -0500

> This is a batch of fixes intended for 3.3.
> 
> The biggest fix comes from Felix, where he moves around some code
> in ath9k in order to avoid a crash reported to him by a user on IRC.
> Also included is an rt2x00 fix from Gabor Juhos for a possible NULL
> pointer dereference, an iwlwifi fix from Johannes Berg for a bug that
> led to incorrectly removing unicast keys (and dropping connections),
> a mac80211 fix from Mohammed Shafi Shajakhan to properly initialize
> a structure used by the rate control algorithms, another mac80211
> fix from Mohammed to avoid a WARNING when changing from monitor mode
> to managed mode, a brcmsmac fix from Arend van Spriel to avoid an
> endless retry of A-MPDU retransmits, and another fix from Arend to
> avoid some log spam coming from brcmsmac.

Pulled, thanks John.
