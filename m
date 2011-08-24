Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1HXC14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:27:56 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:49970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1HXC1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:27:50 -0400
Subject: b43 crash with fragmented packet
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 19:28:03 -0700
Message-ID: <1314152883.4573.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just had a crash in mac80211 with an apparently fragmented packet
(segfault in ieee80211_rx_h_defragment), I can send the stacktrace but I
can't make much sense of it -- anyone see something similar?

johannes

