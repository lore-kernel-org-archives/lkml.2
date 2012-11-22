Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2KVV6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:58:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:49648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab2KVSkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richard.cochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 011/171] ptp: update adjfreq callback description
Date: Wed, 21 Nov 2012 16:39:17 -0800
Message-Id: <20121122004034.452636003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ptp_clock_kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


