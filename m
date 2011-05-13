Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab1EMLgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 07:36:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38786 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1EMLgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 07:36:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCD1824.1060801@jp.fujitsu.com>
Date: Fri, 13 May 2011 20:38:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, riel@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 0/3] swap token revisit
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

They are a patchset of swap token improvement. each patch is independent.
Probably memcg folks are interest to [1/3]. :)


KOSAKI Motohiro (3):
  vmscan,memcg: memcg aware swap token
  vmscan: implement swap token trace
  vmscan: implement swap token priority decay

 include/linux/memcontrol.h    |    6 +++
 include/linux/swap.h          |    8 +---
 include/trace/events/vmscan.h |   81 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c               |   16 +++----
 mm/thrash.c                   |   87 +++++++++++++++++++++++++++++++---------
 mm/vmscan.c                   |    4 +-
 6 files changed, 165 insertions(+), 37 deletions(-)

-- 
1.7.3.1


