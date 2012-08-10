Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449Ab2HJX1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:27:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46567 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab2HJX1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:27:20 -0400
Date: Fri, 10 Aug 2012 16:27:19 -0700 (PDT)
Message-Id: <20120810.162719.2120897808611880641.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-08-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120810183351.GD1950@tuxdriver.com>
References: <20120810183351.GD1950@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 10 Aug 2012 14:33:51 -0400

> Here is a handful of fixes intended for 3.6.
> 
> Daniel Drake offers a cfg80211 fix to consume pending events before
> taking a wireless device down.  This prevents a resource leak.
> 
> Stanislaw Gruszka gives us a fix for a NULL pointer dereference in
> rt61pci.
> 
> Johannes Berg provides an iwlwifi patch to disable "greenfield" mode.
> Use of that mode was causing a rate scaling problem in for iwlwifi.
> 
> Please let me know if there are problems!

Pulled, thanks John.
