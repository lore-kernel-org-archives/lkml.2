Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2CBDHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:07:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49636 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab2CBDHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:07:47 -0500
Date: Thu, 01 Mar 2012 22:07:43 -0500 (EST)
Message-Id: <20120301.220743.2174015405223036036.davem@davemloft.net>
To: alex.shi@intel.com
Cc: feng.tang@intel.com, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        tim.c.chen@intel.com, ying.huang@intel.com, netdev@vger.kernel.org
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330656317.21053.1411.camel@debian>
References: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20120217.133327.1178765872497293871.davem@davemloft.net>
	<1330656317.21053.1411.camel@debian>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Mar 2012 19:07:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>
Date: Fri, 02 Mar 2012 10:45:17 +0800

> Add CC to tang feng, He is working on this issue. 

Is he?  I'm pretty sure this is due to the TCP receive window growing
issue Eric Dumazet, Neal Cardwell and I are discussing in the thread
starting at:

http://marc.info/?l=linux-netdev&m=132916352815286&w=2
