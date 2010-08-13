Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab0HMTp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:45:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:29599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab0HMTp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="827863866"
Message-Id: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 Aug 2010 12:45:39 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: chris@frostnet.net, debian00@aliceadsl.fr, hpa@zytor.com,
        jonathan.protzenko@gmail.com, mans@mansr.com, psastudio@mail.ru,
        rjw@sisk.pl, stephan.eicher@web.de, sxxe@gmx.de, thomas@archlinux.org,
        venki@google.com, wonghow@gmail.com
Subject: [patch 0/3] sched: fixes related to scaling down cpu power with RT tasks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch in the series fixes the main problem reported in the
https://bugzilla.kernel.org/show_bug.cgi?id=15559
(Bad performance after suspend on Intel i7 and i5)

And the next two patches in the series are for issues identified during the
above root cause.

Some reporters of the Bug 15559 still report some unresolved performance
issues after the resume (All the reporters are happy however with the
first patch that fixes the load balancing issue after resume).
Further root cause might result in more patches (scheduler or something else).

For now, I am sending these patches as the first patch in the series is
critical.

Thanks.

