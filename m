Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2AUSEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:51 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58630 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751098Ab2AUSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:34 -0500
Message-ID: <4F1B0BE4.7090401@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:00 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 8/14] kernel-doc: fix new warnings in cfg80211.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warnings:

Warning(include/net/cfg80211.h:1165): No description found for parameter 'channel_type'
Warning(include/net/cfg80211.h:2090): No description found for parameter 'probe_resp_offload'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Johannes Berg <johannes@sipsolutions.net>
Cc:	linux-wireless@vger.kernel.org
---
 include/net/cfg80211.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- lnx-33-rc1.orig/include/net/cfg80211.h
+++ lnx-33-rc1/include/net/cfg80211.h
@@ -1140,6 +1140,7 @@ struct cfg80211_disassoc_request {
  * @bssid: Fixed BSSID requested, maybe be %NULL, if set do not
  *	search for IBSSs with a different BSSID.
  * @channel: The channel to use if no IBSS can be found to join.
+ * @channel_type: channel type (HT mode)
  * @channel_fixed: The channel should be fixed -- do not search for
  *	IBSSs to join on other channels.
  * @ie: information element(s) to include in the beacon
@@ -1978,6 +1979,11 @@ struct wiphy_wowlan_support {
  *	configured as RX antennas. Antenna configuration commands will be
  *	rejected unless this or @available_antennas_tx is set.
  *
+ * @probe_resp_offload:
+ *	 Bitmap of supported protocols for probe response offloading.
+ *	 See &enum nl80211_probe_resp_offload_support_attr. Only valid
+ *	 when the wiphy flag @WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD is set.
+ *
  * @max_remain_on_channel_duration: Maximum time a remain-on-channel operation
  *	may request, if implemented.
  *
