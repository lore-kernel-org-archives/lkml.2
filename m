Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0FTW3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:29:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0FTW3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:29:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Johannes Berg" <johannes.berg@intel.com>,
       "Miles Lane" <miles.lane@gmail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <W8JfMs9cZw.A.NqF.LNpHMB@chimera>
Subject: [Bug #16196] 2.6.35-rc2-git1 - WARNING: at net/wireless/mlme.c:341 cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:17:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16196
Subject		: 2.6.35-rc2-git1 - WARNING: at net/wireless/mlme.c:341 cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-06-07 19:06 (14 days old)
Message-ID	: <AANLkTinmZh9GnrZLzOGi5Q_xHbky8cKdHAkOnsIA6_dZ@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127593758817428&w=2
Handled-By	: Johannes Berg <johannes.berg@intel.com>
Patch		: http://marc.info/?l=linux-wireless&m=127608099427316&w=2


