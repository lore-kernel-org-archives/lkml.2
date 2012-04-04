Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2DDH5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:57:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42817 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2DDH5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:57:09 -0400
Date: Wed, 04 Apr 2012 03:54:14 -0400 (EDT)
Message-Id: <20120404.035414.765974934836327594.davem@davemloft.net>
To: shmulik.ladkani@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCHv1] ipv6: Fix RTM_GETROUTE's interpretation of RTA_IIF
 to be consistent with ipv4
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404105204.63122c38@pixies.home.jungo.com>
References: <20120401170345.5ed75cab@pixies.home.jungo.com>
	<20120401.173032.1881937766187683052.davem@davemloft.net>
	<20120404105204.63122c38@pixies.home.jungo.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 00:54:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Date: Wed, 4 Apr 2012 10:52:04 +0300

> In case of 'alloc_skb' failure, shouldn't we issue a
> 'dst_release(&rt->dst)'?
> 
> If correct, I'll submit a fix. Should have spotted this earlier.

Yep, we need a release there.
