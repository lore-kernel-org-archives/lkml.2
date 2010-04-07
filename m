Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0DGVvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:51:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0DGVvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:51:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Shaohua Li" <shaohua.li@intel.com>,
       "Wu Fengguang" <fengguang.wu@intel.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
In-Reply-To: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JVS2s9dmTsP.A.2EG.7sPvLB@chimera>
Subject: [Bug #15715] vmscan: underflow for get_scan_ratio
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  7 Apr 2010 23:13:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15715
Subject		: vmscan: underflow for get_scan_ratio
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2010-03-30 5:53 (9 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/84b18490d1f1bc7ed5095c929f78bc002eb70f26
Message-ID	: <20100330055304.GA2983@sli10-desk.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=126992842105754&w=4
Handled-By	: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
		  Wu Fengguang <fengguang.wu@intel.com>


