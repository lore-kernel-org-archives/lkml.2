Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1BVSHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:07:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54566
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174Ab1BVSHa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:07:30 -0500
Date: Tue, 22 Feb 2011 10:08:06 -0800 (PST)
Message-Id: <20110222.100806.71122067.davem@davemloft.net>
To: linus.luessing@web.de
Cc: shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au
Subject: Re: Multicast snooping fixes and suggestions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Wed, 16 Feb 2011 00:19:16 +0100

> While testing the (very awesome!) bridge igmp/mld snooping support I came across
> two issues which are breaking IPv6 multicast snooping and IPv6
> non-link-local multicast on bridges with multicast snooping support enabled
> in general. The first two patches shall fix these issues.
> 
> The third one addresses a potential bug on little endian machines which I noticed
> during this little code reviewing. This patch is untested though, feedback welcome.
> 
> The fourth and fifth patch are a suggestion to also permit using the bridge multicast
> snooping feature for link local multimedia multicast traffic. Therefore
> using the transient multicast flag instead of the non-link-local scope criteria
> seems to be a suitable solution at least for IPv6, in my opinion. Let me know what
> you think about it.
> 
> Thanks for reviewing these patches.

Nice work, all applied to net-2.6, thanks!
