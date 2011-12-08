Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1LHVjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:39:41 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33338 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1LHVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:39:38 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 8 Dec 2011 13:39:16 -0800
X-Google-Sender-Auth: AMtV9aK6XjfTENi3SIG77qD2FCg
Message-ID: <CAB=NE6XDHL8mexe49TSoug3COh11RAvVY339Ntj0MJdw96wO1w@mail.gmail.com>
Subject: linux-next base Linus tag
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dani Keerikoolparn <danik@qca.qualcomm.com>,
        "Hoefel, Guilherme" <hoefel@qualcomm.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

If I know a linux-next tag, say next-20110928, how can I extract the
Linus tag you used to start that set of merges for linux-next for?
That is, I am assuming you base your daily linux-next merges on that
day's latest Linus's rc cycle (not just Linus's master tag of that
day). Is that right? If so how can I get that tag?

For example for next-20110928 I see in Next/quilt-import.log:

diff --git a/Next/quilt-import.log b/Next/quilt-import.log
new file mode 100644
index 0000000..a5c7017
--- /dev/null
+++ b/Next/quilt-import.log
@@ -0,0 +1,12 @@
+Importing hexagon based on v3.1-rc6
+Unchanged quilt series hexagon
+Importing i2c based on 3.1-rc4
+Unchanged quilt series i2c
+Importing jdelvare-hwmon based on 3.1-rc4
+Unchanged quilt series jdelvare-hwmon
+Importing kernel-doc based on 3.1-rc3
+Unchanged quilt series kernel-doc
+Importing rr based on v3.1-rc2-188-g6719db6
+Unchanged quilt series rr
+Importing device-mapper based on v3.1-rc7
+Unchanged quilt series device-mapper

So I see some development trees were based circa v3.1 on different rc
cycles, but its unclear to me which one your linux-next was based on
prior to the merge of git trees / quilt trees.

  Luis
