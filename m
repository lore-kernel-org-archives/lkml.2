Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1HFMei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 08:34:38 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:52968 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1HFMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 08:34:36 -0400
Subject: [PATCH] [TRIVIAL] Fix documentation and comment typo 'no_hz'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>, Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Aug 2011 14:33:43 +0200
Message-ID: <1312634023.2021.7.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested (which I suppose is acceptable with trivialities like this
as long as one is honest about it).

1) Also sent to Dave Jones and cpufreq@vger.kernel.org because it's hard
to say (for me) what was meant by "no_hz" in that comment. But there
were only two hits for "no_hz" in the kernel tree and lots of hits for
"nohz" so I guessed "nohz" is the term to be used there too.

 Documentation/cpu-freq/governors.txt |    2 +-
 drivers/cpufreq/cpufreq_ondemand.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index e74d0a2..d221781 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -132,7 +132,7 @@ The sampling rate is limited by the HW transition latency:
 transition_latency * 100
 Or by kernel restrictions:
 If CONFIG_NO_HZ is set, the limit is 10ms fixed.
-If CONFIG_NO_HZ is not set or no_hz=off boot parameter is used, the
+If CONFIG_NO_HZ is not set or nohz=off boot parameter is used, the
 limits depend on the CONFIG_HZ option:
 HZ=1000: min=20000us  (20ms)
 HZ=250:  min=80000us  (80ms)
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 891360e..629b3ec 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -725,7 +725,7 @@ static int __init cpufreq_gov_dbs_init(void)
 		dbs_tuners_ins.down_differential =
 					MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
 		/*
-		 * In no_hz/micro accounting case we set the minimum frequency
+		 * In nohz/micro accounting case we set the minimum frequency
 		 * not depending on HZ, but fixed (very low). The deferred
 		 * timer might skip some samples if idle/sleeping as needed.
 		*/
-- 
1.7.4.4

