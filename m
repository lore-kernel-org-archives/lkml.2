Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1DQAPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 20:15:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4752 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1DQAP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 20:15:29 -0400
From: Joe Perches <joe@perches.com>
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>, netdev@vger.kernel.org
Cc: Roger Luethi <rl@hellgate.ch>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] via-rhine: Logging cleanups and use random MAC address
Date: Sat, 16 Apr 2011 17:15:24 -0700
Message-Id: <cover.1302998994.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <4DAA12C0.7030106@gmail.com>
References: <4DAA12C0.7030106@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandru's patch didn't apply so use the
current logging standards and fix the whitespace
in Alexandru's patch.

Joe Perches (2):
  via_rhine: Use netdev_<level> and pr_<level>
  via-rhine: Assign random MAC address if necessary

 drivers/net/via-rhine.c |  240 ++++++++++++++++++++++-------------------------
 1 files changed, 114 insertions(+), 126 deletions(-)

-- 
1.7.4.2.g597a6.dirty

