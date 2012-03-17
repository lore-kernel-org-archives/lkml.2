Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2CQF6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 01:58:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2CQF6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 01:58:24 -0400
Date: Fri, 16 Mar 2012 22:58:19 -0700 (PDT)
Message-Id: <20120316.225819.536895807414721517.davem@davemloft.net>
To: panweiping3@gmail.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2] bonding: send igmp report for its master
From: David Miller <davem@davemloft.net>
In-Reply-To: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
References: <f5d199e12d78dadcfb932e103984276d36b186e0.1331539261.git.panweiping3@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Mar 2012 22:58:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weiping Pan <panweiping3@gmail.com>
Date: Wed, 14 Mar 2012 11:37:22 +0800

> +	if (unlikely(master_dev)) {
> +		__bond_resend_igmp_join_requests(master_dev);
> +	}

Please do not enclose a single-statement basic block inside of
braces.

