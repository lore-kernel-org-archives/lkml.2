Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1DOWqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:46:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36291
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958Ab1DOWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:46:19 -0400
Date: Fri, 15 Apr 2011 15:45:44 -0700 (PDT)
Message-Id: <20110415.154544.102557027.davem@davemloft.net>
To: sahne@0x90.at
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: RTA_PREFSRC support for ipv6 route source
 address selection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110414071057.GB78446@0x90.at>
References: <20110414071057.GB78446@0x90.at>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <sahne@0x90.at>
Date: Thu, 14 Apr 2011 09:10:57 +0200

> [ipv6] Add support for RTA_PREFSRC
> 
> This patch allows a user to select the preferred source address
> for a specific IPv6-Route. It can be set via a netlink message
> setting RTA_PREFSRC to a valid IPv6 address which must be
> up on the device the route will be bound to.
> 
> 
> Signed-off-by: Daniel Walter <dwalter@barracuda.com>

Applied to net-next-2.6

> +		err = ip6_route_get_saddr(net, rt, &fl6->daddr, 
                                                                ^^

This line had trailing whitespace, please avoid this in the future
as GIT complains about it and I have to fix it up by hand.
