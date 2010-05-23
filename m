Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0EWLY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 07:24:28 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:56623 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab0EWLYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 07:24:23 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 May 2010 07:24:23 EDT
Subject: [PATCH 0/2] ISDN fixes for 2.6.35
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20100523-patch-gigaset-00.tilman@imap.cc>
Date: Sun, 23 May 2010 13:01:38 +0200 (CEST)
X-Spam-Score: -0.671 () AWL,BAYES_40,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten, David,

following are two patches to the CAPI subsystem and the Gigaset
driver I'd like to see included in kernel release 2.6.35.
Together they fix a reported hang of the userspace command
"capiinit stop".

Thanks,
Tilman

Tilman Schmidt (3):
  isdn/capi: make reset_ctr op truly optional
  isdn/gigaset: remove dummy CAPI method implementations

 drivers/isdn/capi/kcapi.c   |    6 ++++++
 drivers/isdn/gigaset/capi.c |   28 ++--------------------------
 2 files changed, 8 insertions(+), 26 deletions(-)
