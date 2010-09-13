Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0IMUQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:16:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64733 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0IMUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HnksunL32j1vhCUrPopJtf0Xra6qBmD5lJXdJ0iF5Gad61m0f+hr9Ik2cjK7UZrFFp
         d55fqsj5BY3I9WcbjoqChmq8XQJILvuNcGGoexK4Kb+ZrzFch2hxJ46O00bYifG6Shsy
         +7LB/TjS6QUW8GTbpY6Ti1OwKv7shMYXwIvLQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        clemens@ladisch.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3 v2]sound/pci/intel8x0.c Update broken web addresses.
Date: Mon, 13 Sep 2010 13:17:03 -0700
Message-Id: <1284409023-4419-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284409023-4419-1-git-send-email-justinmattock@gmail.com>
References: <1284409023-4419-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend from the original, due to Clemens Ladisch providing
the right locations of the *.pdf's etc..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 sound/pci/intel8x0.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 4677492..400f9eb 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -716,7 +716,7 @@ static void snd_intel8x0_setup_periods(struct intel8x0 *chip, struct ichdev *ich
  * Intel 82443MX running a 100MHz processor system bus has a hardware bug,
  * which aborts PCI busmaster for audio transfer.  A workaround is to set
  * the pages as non-cached.  For details, see the errata in
- *	http://www.intel.com/design/chipsets/specupdt/245051.htm
+ *	http://download.intel.com/design/chipsets/specupdt/24505108.pdf
  */
 static void fill_nocache(void *buf, int size, int nocache)
 {
-- 
1.7.2.1

