Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2LMODy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab2LMODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richard.cochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 050/241] ptp: update adjfreq callback description
Date: Thu, 13 Dec 2012 11:56:55 -0200
Message-Id: <1355407206-17100-51-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit 87f4d7c1d36f44b0822053b7e5dedc31fdd0ab99 upstream.

This patch updates the adjfreq callback description to include a note that the
delta in ppb is always relative to the base frequency, and not to the current
frequency of the hardware clock.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
CC: Richard Cochran <richard.cochran@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ptp_clock_kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 945704c..00b9e61 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -50,7 +50,8 @@ struct ptp_clock_request {
  * clock operations
  *
  * @adjfreq:  Adjusts the frequency of the hardware clock.
- *            parameter delta: Desired period change in parts per billion.
+ *            parameter delta: Desired frequency offset from nominal frequency
+ *            in parts per billion
  *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.
-- 
1.7.9.5

