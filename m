Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2IBCtC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 22:49:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2IBCtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 22:49:00 -0400
Date: Sat, 01 Sep 2012 22:48:58 -0400 (EDT)
Message-Id: <20120901.224858.1302164250000326522.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        tony.cheneau@amnesiak.org, linux-zigbee-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] 6lowpan fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346515027-5237-1-git-send-email-alan@signal11.us>
References: <1346294341-26808-1-git-send-email-alan@signal11.us>
	<1346515027-5237-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Sat,  1 Sep 2012 11:57:05 -0400

> v3 of this patch changes skb_copy() to skb_clone() in patch #1 at the
> recommendation of Eric Dumazet
> 
> Alan Ott (2):
>   6lowpan: Make a copy of skb's delivered to 6lowpan
>   6lowpan: handle NETDEV_UNREGISTER event

All applied to net-next, thanks.
