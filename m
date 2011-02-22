Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1BVSHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:07:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44203
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912Ab1BVSHr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:07:47 -0500
Date: Tue, 22 Feb 2011 10:08:23 -0800 (PST)
Message-Id: <20110222.100823.189696335.davem@davemloft.net>
To: linus.luessing@web.de
Cc: shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 2/2] bridge: Use IPv6 link-local address for multicast
 listener queries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297966672-3457-3-git-send-email-linus.luessing@web.de>
References: <20110215154128.2a28632c@nehalam>
	<1297966672-3457-3-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Thu, 17 Feb 2011 19:17:52 +0100

> Currently the bridge multicast snooping feature periodically issues
> IPv6 general multicast listener queries to sense the absence of a
> listener.
> 
> For this, it uses :: as its source address - however RFC 2710 requires:
> "To be valid, the Query message MUST come from a link-local IPv6 Source
> Address". Current Linux kernel versions seem to follow this requirement
> and ignore our bogus MLD queries.
> 
> With this commit a link local address from the bridge interface is being
> used to issue the MLD query, resulting in other Linux devices which are
> multicast listeners in the network to respond with a MLD response (which
> was not the case before).
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied.
