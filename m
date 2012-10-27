Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2J0TuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:50:24 -0400
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:54041 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932719Ab2J0TuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:50:23 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2012 15:50:23 EDT
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH 2/2] MAINTAINERS: add pinctrl atmel at91 entry
Date: Sat, 27 Oct 2012 19:53:12 +0200
Message-Id: <1351360392-8669-2-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1351360392-8669-1-git-send-email-plagnioj@jcrosoft.com>
References: <1351360392-8669-1-git-send-email-plagnioj@jcrosoft.com>
X-Ovh-Tracer-Id: 2309220710782184445
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecunecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpefhvffufffkofgjfhestddtredtredttd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecunecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpefhvffufffkofgjfhestddtredtredttd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 027ec2b..cb97031 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5624,6 +5624,12 @@ S:	Maintained
 F:	drivers/pinctrl/
 F:	include/linux/pinctrl/
 
+PIN CONTROLLER - ATMEL AT91
+M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/pinctrl/pinctrl-at91.c
+
 PIN CONTROLLER - ST SPEAR
 M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
-- 
1.7.10.4

