Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2CGUkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:40:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53342 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2CGUke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:40:34 -0500
Date: Wed, 07 Mar 2012 15:39:13 -0500 (EST)
Message-Id: <20120307.153913.824845751182717386.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-03-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120306201528.GC3353@tuxdriver.com>
References: <20120306201528.GC3353@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Mar 2012 12:39:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 6 Mar 2012 15:15:28 -0500

> Here are a few more squeakers hoping for 3.3...
> 
> Two of them are for carl9170: a one-line fix for a memory accounting
> leak; and a fix that corrects the handling of frames with a couple of
> status flags set by mac80211 (enabling delivery to sleeping stations).
> Also included is a one-liner for mwifiex that should have been included
> in "mwifiex: clear previous security setting during association".
> Finally, a one-line fix from Johannes Berg for an iwlwifi regression
> brings-up the rear.
> 
> Please let me know if there are problems!

Pulled, but no promises getting these into 3.3
