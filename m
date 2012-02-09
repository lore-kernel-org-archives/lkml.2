Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2BIAOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 19:14:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2BIAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 19:14:29 -0500
Date: Wed, 08 Feb 2012 19:13:12 -0500 (EST)
Message-Id: <20120208.191312.797325617283169736.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120208203702.GE2929@tuxdriver.com>
References: <20120208203702.GE2929@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 16:13:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 8 Feb 2012 15:37:02 -0500

> This is a batch of fixes intended for 3.3.
> 
> Included is a fix for an association failure bug with mwifiex, and a fix
> for a NULL pointer deref in that same driver.  There is also an ath9k
> fix for a WEP-related regression, and another ath9k fix for an RTS/CTS
> timeout regression.  A third ath9k fix address an oops during driver
> initialization.  Also included is a zd1211rw fix for an issue where the
> firmware would corrupt the duration_id setting and cause devices to be
> unable to connect to zd1211rw-based APs.  A fix from me to reduce some
> log spam from ath9k rounds-out the bunch.
> 
> Please let me know if there are problems!

Pulled, thanks John.
