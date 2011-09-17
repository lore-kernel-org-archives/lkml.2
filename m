Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1IQVOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 17:14:30 -0400
Received: from 216-146-103-100.dsl.nemontel.net ([216.146.103.100]:40788 "EHLO
	silka.with-linux.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1IQVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 17:14:29 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Sep 2011 17:14:29 EDT
Message-ID: <4E750964.8060502@silka.with-linux.com>
Date: Sat, 17 Sep 2011 14:56:04 -0600
From: Kelly Anderson <kelly@silka.with-linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110911 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH]: fix regulaotry misspelling in net/wireless/reg.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick patch to fix a typo.  Signed off by me.


I'm not subscribed to the mailing list currently.

--- ./net/wireless/reg.c.orig    2011-08-29 14:56:30.000000000 -0600
+++ ./net/wireless/reg.c    2011-09-17 14:42:38.305715253 -0600
@@ -903,7 +903,7 @@ static bool ignore_reg_update(struct wip
          initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
          !is_world_regdom(last_request->alpha2)) {
          REG_DBG_PRINT("Ignoring regulatory request %s "
-                  "since the driver requires its own regulaotry "
+                  "since the driver requires its own regulatory "
                    "domain to be set first",
                    reg_initiator_name(initiator));
          return true;

