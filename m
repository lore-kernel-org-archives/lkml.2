Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab0FTWcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:32:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58620 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693Ab0FTW3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:29:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Miles Lane" <miles.lane@gmail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <W8JfMs9cZw.A.sSF.DNpHMB@chimera>
Subject: [Bug #16199] 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked rcu_dereference_check() without protection!
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16199
Subject		: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked rcu_dereference_check() without protection!
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-06-07 18:14 (14 days old)
Message-ID	: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127593447812015&w=2


