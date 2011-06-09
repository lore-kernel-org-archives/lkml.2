Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1FICvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:51:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48316 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1FICvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HvGe1LdU3rPS3XX15tgBbxMFDtIZYv0gQG3pBKHkW88Giivl2uz+6n3nrXQ93i2d/s
         A7zcfO1hu48gGpNoC2pV7ClHUvXHvkP1AA+/UU9OvHi8Hlr0RSHfgxPU5JkHOaoJYedV
         UAY5bwWvFFa9/o6W3VSiz8RVYbUWo8UGcV5IY=
From: Weiping Pan <panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net-next 0/2] bonding: delete two unused variables
Date: Thu,  9 Jun 2011 10:51:32 +0800
Message-Id: <cover.1307587586.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete two unused variables in bonding.

Weiping Pan (2):
  bonding: delete unused ad_timer
  bonding: delete unused arp_mon_pt

 drivers/net/bonding/bond_3ad.h |    1 -
 drivers/net/bonding/bonding.h  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

-- 
1.7.4.4

