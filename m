Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0IZU2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:28:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab0IZU2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:28:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Thomas Meyer" <thomas@m3y3r.de>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
In-Reply-To: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sQALkqF1FWE.A.NgE.Hp6nMB@chimera>
Subject: [Bug #17722] 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Sep 2010 22:04:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17722
Subject		: 2.6.36-rc3: WARNING: at net/mac80211/scan.c:269 ieee80211_scan_completed
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-08-31 20:14 (27 days old)
Message-ID	: <201008312214.52473.thomas@m3y3r.de>
References	: http://marc.info/?l=linux-kernel&m=128328580504227&w=2
		  http://www.spinics.net/lists/netdev/msg140769.html


