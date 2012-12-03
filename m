Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2LCOlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:41:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503Ab2LCOg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:56 -0500
Message-Id: <20121203143153.159954532@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richard.cochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/89] ptp: update adjfreq callback description
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ptp_clock_kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index f2dc6d8..38a9935 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -54,7 +54,8 @@ struct ptp_clock_request {
  * clock operations
  *
  * @adjfreq:  Adjusts the frequency of the hardware clock.
- *            parameter delta: Desired period change in parts per billion.
+ *            parameter delta: Desired frequency offset from nominal frequency
+ *            in parts per billion
  *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.


