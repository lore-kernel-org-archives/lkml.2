Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2ALULi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:11:38 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40597 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2ALULe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:11:34 -0500
Date: Thu, 12 Jan 2012 12:10:23 -0800 (PST)
Message-Id: <20120112.121023.570915351051554327.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120112184919.GK11093@tuxdriver.com>
References: <20120112184919.GK11093@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Jan 2012 12:10:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 12 Jan 2012 13:49:19 -0500

> Here is a quick batch of wireless fixes intended for 3.3!
> 
> On the Bluetooth patches, Gustavo says this:
> 
> "A couple of fixes for the 3.3 release. The majority of the fixes are
> related to the change from tasklets to workqueue in the Bluetooth
> Core. The rest are important fixes over the tree. Exception is
> 'Bluetooth: Rename extfeatures', as the name says it is just a rename
> and no harm, but it is a preparation for a following fix."
> 
> Also included is a fix from Jesper Juhl for a potential memory leak in
> brcm80211, a one-line comment fix (plus a couple of lines of removing
> unused code) from Mohammed Shafi Shajakhan in ath9k, a fix from Larry
> Finger to prevent hitting a BUG in rtl8192se when an skb allocation
> fails, a fix from Stanislaw Gruszka for a NULL pointer dereference
> in mac80211, a fix from Rajkumar Manoharan for an ath9k regression
> relating to channel noisefloor readings, and a fix from Johannes Berg
> for a regression related to parsing station flags.
> 
> Hopefully all of these are fine for the merge window.  Please let me
> know if there are problems!

Pulled, thanks John.
