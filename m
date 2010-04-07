Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0DGVtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:49:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0DGVtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:49:09 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alex Zhavnerchik" <alex.vizor@gmail.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
In-Reply-To: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JVS2s9dmTsP.A.Va.WuPvLB@chimera>
Subject: [Bug #15551] WARNING: at net/mac80211/work.c:811 ieee80211_work_work+0x7f/0xde8 [mac80211]()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  7 Apr 2010 23:13:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15551
Subject		: WARNING: at net/mac80211/work.c:811 ieee80211_work_work+0x7f/0xde8 [mac80211]()
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2010-03-16 22:03 (23 days old)


