Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2EJBWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:22:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44970 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab2EJBWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:22:20 -0400
Date: Wed, 09 May 2012 21:21:10 -0400 (EDT)
Message-Id: <20120509.212110.437114897180819434.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 00/13] net: Add and use ether_addr_equal
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1336538937.git.joe@perches.com>
References: <cover.1336538937.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 May 2012 18:21:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue,  8 May 2012 21:56:44 -0700

> Add a boolean function to test 2 ethernet addresses for equality
> Convert compare_ether_addr uses to ether_addr_equal

This series looks great, I'll apply all of it.

Thanks Joe.

That case you didn't convert in mac80211 is probably the
bug Johannes was talking about which started this whole
discussion.
