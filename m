Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2H3CjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 22:39:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33334 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206Ab2H3CjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 22:39:08 -0400
X-Sasl-enc: KfLtSr878Rdbc5/alnlZCSXbSsoZXgK0ACnKbacsSlHp 1346294347
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Cheneau <tony.cheneau@amnesiak.org>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/2] 6lowpan fixes
Date: Wed, 29 Aug 2012 22:38:59 -0400
Message-Id: <1346294341-26808-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for 6lowpan.

I'm sorry about the other two emails that just went out with the same
subject.  One day I'm going to start getting these right on the first try.

Alan Ott (2):
  6lowpan: Make a copy of skb's delivered to 6lowpan
  6lowpan: handle NETDEV_UNREGISTER event

 net/ieee802154/6lowpan.c |   53 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 45 insertions(+), 8 deletions(-)

