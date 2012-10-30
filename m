Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2J3Qt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:49:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55749 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899Ab2J3Qty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:49:54 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com, amit.kachhap@linaro.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V3 1/5] Thermal: add indent for code alignment.
Date: Tue, 30 Oct 2012 17:48:57 +0100
Message-Id: <1351615741-24134-2-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
 <1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

The curly bracket should be aligned with corresponding if else statements.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/thermal/cpu_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index cc1c930..b6b4c2a 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -369,7 +369,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 			if (min != policy.cpuinfo.min_freq ||
 				max != policy.cpuinfo.max_freq)
 				return ERR_PTR(-EINVAL);
-}
+		}
 	}
 	cpufreq_dev = kzalloc(sizeof(struct cpufreq_cooling_device),
 			GFP_KERNEL);
-- 
1.7.11.3

