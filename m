Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0FHLxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:53:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47185 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0FHLxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:53:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [0/10] 3rd pile of OOM patch series 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100608204621.767A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:53:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is 3rd pile of collection of OOM patches.
I think they don't immix anyone objected patch. but please double check.


=====================================================================
 Documentation/sysctl/vm.txt |    2 +-
 fs/proc/base.c              |    4 +-
 include/linux/mempolicy.h   |   13 +++-
 include/linux/oom.h         |    8 ++
 kernel/sysctl.c             |    4 +-
 mm/mempolicy.c              |   44 ++++++++++++
 mm/oom_kill.c               |  156 ++++++++++++++++++++++---------------------
 7 files changed, 146 insertions(+), 85 deletions(-)



