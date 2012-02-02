Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2BBX3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:29:16 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50372 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2BBX3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:29:15 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 15:29:08 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Woogyom Kim <milo.kim@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH] include/linux/lp8727.h: Remove executable bit
Message-ID: <20120202232908.GA20195@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
First time I've sent a patch with this diffstat, but I assume git can
properly apply it.

 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 include/linux/lp8727.h

diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
old mode 100755
new mode 100644
-- 
1.7.9

