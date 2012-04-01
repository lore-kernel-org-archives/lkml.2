Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2DAULu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:11:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44345 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2DAULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:11:38 -0400
Date: Sun, 01 Apr 2012 16:10:31 -0400 (EDT)
Message-Id: <20120401.161031.886756026206260043.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-03-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120330175533.GC8273@tuxdriver.com>
References: <20120330175533.GC8273@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 13:10:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 30 Mar 2012 13:55:34 -0400

> I have a few more small fixes, hopefully still in time for 3.4-rc1...
> 
> Rajkukmar provides us with a one-line timestamp correction related to
> scanning in mac80211.  Sujith gives us a small fixup for a regression
> in the handling of HT capability bits for ath9k.  Stanislav Yakovlev
> is stepping-up as maintainer for the ipw2x00 drivers, so we'll add
> him to MAINTAINERS.  Stanislav also gives us a fix for a thinko
> that registers the wrong band information for ipw2200 and 802.11a.
> Finally, Santosh Nayak adds some simple error checking to orinoco to
> avoid some potential NULL pointer dereferences.

Pulled, thanks John.
