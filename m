Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2IAP5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 11:57:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51451 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab2IAP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 11:57:18 -0400
X-Sasl-enc: PBSmz3SsyPDrrk8wNInwDwspKisirjipPRV976fTfDA2 1346515037
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Cheneau <tony.cheneau@amnesiak.org>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 0/2] 6lowpan fixes
Date: Sat,  1 Sep 2012 11:57:05 -0400
Message-Id: <1346515027-5237-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346294341-26808-1-git-send-email-alan@signal11.us>
References: <1346294341-26808-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 of this patch changes skb_copy() to skb_clone() in patch #1 at the
recommendation of Eric Dumazet

Alan Ott (2):
  6lowpan: Make a copy of skb's delivered to 6lowpan
  6lowpan: handle NETDEV_UNREGISTER event

 net/ieee802154/6lowpan.c |   53 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 45 insertions(+), 8 deletions(-)

