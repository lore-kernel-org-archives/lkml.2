Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1AaOEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:04:16 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46460 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab1AaOEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: akpm@linux-foundation.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: 
Date: Mon, 31 Jan 2011 15:03:52 +0100
Message-Id: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

these three patches are small fixes for urgent issues with memory
cgroups and transparent huge pages.  They are inspired by 4/7 of
KAMEZAWA-san's recent series 'memcg : more fixes and clean up for
2.6.28-rc' to make memory cgroups work with THP.

2/3 fixes a bug that is first uncovered through 1/3.  Minchan
suggested this order for review purposes, but they should probably be
applied the other way round (2, then 1) for better bisectability.

If everybody agrees, I would prefer these going into -mmotm now, and
have further cleanups and optimizations based on them.

	Hannes

