Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1HTAop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 20:44:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47125 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1HTAon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 20:44:43 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Aug 2011 17:44:22 -0700
Message-ID: <CAB=NE6XmMJk8mKAM-LB5Jh3ZV1k57RMsCzQ19Z+Ly-BFmk8cVQ@mail.gmail.com>
Subject: Linux wireless summit videoes from LinuxCon 2011
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those that could not make it to the 2011 Linux wireless summit at
LinuxCon Vancouver we have up 3 videoes on YouTube:

1) [RFC] 802.11 DFS design on mac80211 / ath9k

http://www.youtube.com/watch?v=_yyFiLFx4Mg

Saxnet present their latest effort on design for a DFS architecture
for mac80211 and for ath9k. This is from LinuxCon 2011 this week.
Saxnet did an awesome job. If this design works for certification it
could mean lowering the entry price for AP vendors looking to pass DFS
testing. This work is under review now.

2) 802.11s on LInux mac80211

802.11s Mesh Networking was ratified by IEEE for integration into
802.11. Javier Cardona has been leading its implementation and support
on mac80211. In this session he reviews 802.11s with open and
encrypted environments. 802.11s uses a different encryption algorithm
called "simultaneous authentication of equals", Javier reviews work
needed to integrate the userspace application required supporting this
encryption mechanism on hostapd / wpa_supplicant.

3) wmediumd for mac80211_hwsim

Javier Cardona explains what Cozybit used to test the 802.11s code
implemented in mac80211. He used extensions to mac80211_hwsim that
allow links to be lossy. Cozybit also wrote a daemon to communicate to
mac80211_hwsim to statically or dynamically alter the characteristics
of the links. Right now mac80211_hwsim only accounts for packet loss
between links but extensions can be made to also add latency later. He
also demos a Java application used to create your topology for
mac80211_hwsim. Researchers should get a chubby with this framework --
you can extend this to do really cool shit, all in software with no
hardware.

--

Kudos to Saxnet and Cozybit for their presentations and *awesome* work
on coding up stuff and doing a great job at explaining all this to us.

Nothing else was recorded, sorry :) If you loose the links you'll be
able to find them here:

http://wireless.kernel.org/en/users/Documentation#YouTube_Documentation

  Luis
