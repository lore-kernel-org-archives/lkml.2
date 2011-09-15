Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997Ab1IOVNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934775Ab1IOVN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:13:29 -0400
Date: Thu, 15 Sep 2011 17:13:20 -0400 (EDT)
Message-Id: <20110915.171320.2277087899608297535.davem@redhat.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-09-15
From: David Miller <davem@redhat.com>
In-Reply-To: <20110915194814.GC24589@tuxdriver.com>
References: <20110915194814.GC24589@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 15 Sep 2011 15:48:15 -0400

> Here is a batch of fixes intended for 3.1.  Included is a calibration
> fix for ath9k that avoids a hang, a couple of rtlwifi fixes for
> connection failures, a mac80211 locking fix, a couple of iwlagn fixes
> (including a corruption fix), an ath9k oops fix, an initialization
> fix for AR9330 hardware in ath9k, and a patch to avoid a needless
> BUG_ON in iwlegacy.
> 
> Please let me know if there are problems!

Pulled, thanks John.
