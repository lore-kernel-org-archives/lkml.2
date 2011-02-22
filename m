Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1BVSHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:07:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54575
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab1BVSHl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:07:41 -0500
Date: Tue, 22 Feb 2011 10:08:17 -0800 (PST)
Message-Id: <20110222.100817.104065329.davem@davemloft.net>
To: linus.luessing@web.de
Cc: shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 1/2] bridge: Fix MLD queries' ethernet source address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297966672-3457-2-git-send-email-linus.luessing@web.de>
References: <20110215154128.2a28632c@nehalam>
	<1297966672-3457-2-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Thu, 17 Feb 2011 19:17:51 +0100

> Map the IPv6 header's destination multicast address to an ethernet
> source address instead of the MLD queries multicast address.
> 
> For instance for a general MLD query (multicast address in the MLD query
> set to ::), this would wrongly be mapped to 33:33:00:00:00:00, although
> an MLD queries destination MAC should always be 33:33:00:00:00:01 which
> matches the IPv6 header's multicast destination ff02::1.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied.
