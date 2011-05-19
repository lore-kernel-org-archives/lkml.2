Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab1ESSx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:53:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40153 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058Ab1ESSxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:53:55 -0400
Date: Thu, 19 May 2011 14:52:26 -0400 (EDT)
Message-Id: <20110519.145226.81502363776050802.davem@davemloft.net>
To: sven@narfation.org
Cc: ordex@autistici.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paulus@samba.org, linux-ppp@vger.kernel.org
Subject: Re: net: add seq_before/seq_after functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <201105191121.23888.sven@narfation.org>
References: <201105191054.34912.sven@narfation.org>
	<20110519.050824.838971689287732822.davem@davemloft.net>
	<201105191121.23888.sven@narfation.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 May 2011 11:52:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>
Date: Thu, 19 May 2011 11:21:21 +0200

> This is currently used by vis.c in net/batman-adv and could also be used by 
> ppp-generic.c (with my changes of course). And it is planned to be used by 
> transtable.c in net/batman-adv. The idea was to propose this to linux-
> kernel/netdev before we move it to a place were only batman-adv can use it 
> (the current situation is that vis.c in batman-adv can only use it).
> 
> It is ok that you say that it should be batman-adv specific - we only wanted 
> to ask first.

Well, this is a purely networking change, the header you're touching is
networking specific, so really in this case linux-kernel didn't need to
get involved :-)
