Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1KHJQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:16:11 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:58320 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1KHJQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:16:06 -0500
Subject: [PATCH] [TRIVIAL] Documentation: cpufreq: Fix typo and outdated
 line
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 10:16:03 +0100
Message-ID: <1320743763.14409.375.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'sampling_rate_max' was removed with commit ef598549 ("[...] Remove
deprecated sysfs file sampling_rate_max"), so its line can be dropped
from governors.txt. And 'show_sampling_rate_min' is a typo: the sysfs
file is called 'sampling_rate_min'.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/cpu-freq/governors.txt |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index d221781..c7a2eb8 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -127,7 +127,7 @@ in the bash (as said, 1000 is default), do:
 echo `$(($(cat cpuinfo_transition_latency) * 750 / 1000)) \
     >ondemand/sampling_rate
 
-show_sampling_rate_min:
+sampling_rate_min:
 The sampling rate is limited by the HW transition latency:
 transition_latency * 100
 Or by kernel restrictions:
@@ -140,8 +140,6 @@ HZ=100:  min=200000us (200ms)
 The highest value of kernel and HW latency restrictions is shown and
 used as the minimum sampling rate.
 
-show_sampling_rate_max: THIS INTERFACE IS DEPRECATED, DON'T USE IT.
-
 up_threshold: defines what the average CPU usage between the samplings
 of 'sampling_rate' needs to be for the kernel to make a decision on
 whether it should increase the frequency.  For example when it is set
-- 
1.7.4.4



