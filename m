Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab0HOTCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 15:02:41 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:57627 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab0HOTCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 15:02:40 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2010 15:02:40 EDT
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] intel_idle: remove executable permission from intel_idle.c
Date: Sun, 15 Aug 2010 15:55:45 -0300
Message-Id: <1281898545-3156-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/idle/intel_idle.c

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
old mode 100755
new mode 100644
-- 
1.7.2.1

