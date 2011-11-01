Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1KAPSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:18:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47652 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1KAPSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:18:45 -0400
Message-ID: <4EB00DD3.7090701@gmail.com>
Date: Tue, 01 Nov 2011 08:18:43 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@kernel.org,
        linux-wireless@vger.kernel.org
Subject: spamm of cfg80211: Calling CRDA to update world regulatory domain
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is there a way to get rid of this annoying spamming of the regulatory?


[  338.519037] cfg80211: Calling CRDA to update world regulatory domain
[  338.523266] cfg80211: World regulatory domain updated:
[  338.523269] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  338.523272] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  338.523276] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  338.523279] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  338.523281] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  338.523284] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  340.948738] wlan1: authenticate with 00:1d:a2:d8:7e:70 (try 1)
[  340.950479] wlan1: authenticated
[  340.950707] wlan1: associate with 00:1d:a2:d8:7e:70 (try 1)
[  340.953611] wlan1: RX ReassocResp from 00:1d:a2:d8:7e:70 (capab=0x401 
status=0 aid=79)
[  340.953614] wlan1: associated
[  458.646604] wlan1: deauthenticated from 00:1d:a2:d8:7e:70 (Reason: 2)


my entire syslog is filled with the above.

Note: I am not on the list so Cc me!

Justin P. Mattock
