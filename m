Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935373Ab0KQTVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:21:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58675
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934924Ab0KQTVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:21:46 -0500
Date: Wed, 17 Nov 2010 11:22:10 -0800 (PST)
Message-Id: <20101117.112210.232752115.davem@davemloft.net>
To: jeder@redhat.com
Cc: netdev@vger.kernel.org, rdunlap@xenotime.net, opurdila@ixiacom.com,
        apetlund@simula.no, William.Allen.Simpson@gmail.com,
        ian.campbell@citrix.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Subject: Re: [PATCH net-next-2.6] clarify documentation for
 net.ipv4.igmp_max_memberships
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289835691.8257.1274.camel@jerms-wks.usersys.redhat.com>
References: <1289835691.8257.1274.camel@jerms-wks.usersys.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Eder <jeder@redhat.com>
Date: Mon, 15 Nov 2010 10:41:31 -0500

> This patch helps clarify documentation for
> net.ipv4.igmp_max_memberships by providing a formula for
> calculating the maximum number of multicast groups that can be
> subscribed to, plus defining the theoretical limit.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> Signed-off-by: Jeremy Eder <jeder@redhat.com>

Applied, thanks Jeremy.
