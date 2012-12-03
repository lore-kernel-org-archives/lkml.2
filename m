Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2LCKeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:34:22 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57383 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2LCKeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:34:21 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] drivers:staging: fix compilation warning
Date: Mon,  3 Dec 2012 10:34:08 +0000
Message-Id: <1354530848-12516-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not allow old-style function definition.  Always spell foo(void) if
a function does not take any parameters.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/staging/telephony/ixj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/telephony/ixj.c b/drivers/staging/telephony/ixj.c
index 1cfa0b0..6233f19 100644
--- a/drivers/staging/telephony/ixj.c
+++ b/drivers/staging/telephony/ixj.c
@@ -318,7 +318,7 @@ static IXJ *ixj[IXJMAX];
  *	Allocate a free IXJ device
  */
 
-static IXJ *ixj_alloc()
+static IXJ *ixj_alloc(void)
 {
 	for(cnt=0; cnt<IXJMAX; cnt++)
 	{
-- 
1.7.4.5

