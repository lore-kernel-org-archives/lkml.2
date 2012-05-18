Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150Ab2ERW4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:56:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43255 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030441Ab2ERW4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:56:38 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] cirrus: cs89x0: Neatening
Date: Fri, 18 May 2012 15:56:26 -0700
Message-Id: <cover.1337381533.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, some might consider it gratuitous.
I think it's cleaner now though.

Joe Perches (5):
  cirrus: cs89x0: Code style neatening
  cirrus: cs89x0: Convert printks to pr_<level>
  cirrus: cs89x0: Code neatening
  cirrus: cs89x0: Neaten debugging and logging
  cirrus: cs89x0: Remove function prototypes and reorder declarations

 drivers/net/ethernet/cirrus/cs89x0.c | 2408 +++++++++++++++++-----------------
 1 files changed, 1185 insertions(+), 1223 deletions(-)

-- 
1.7.8.111.gad25c.dirty

