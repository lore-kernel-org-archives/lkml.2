Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2EUXoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:44:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2EUXoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:44:13 -0400
From: NeilBrown <neilb@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 22 May 2012 09:43:02 +1000
Subject: [PATCH] Two fixes for omap_hdq
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Message-ID: <20120521234241.13661.59150.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
 you seem to process patches for drivers/w1.  Could you please
take these two, both acked by the maintainer.

Thanks,
NeilBrown


---

NeilBrown (2):
      omap_hdq: use wait_event_timeout to wait for read to complete.
      omap_hdq: Fix some error/debug handling.


 drivers/w1/masters/omap_hdq.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

-- 
Signature

