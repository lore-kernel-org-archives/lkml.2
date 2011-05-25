Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab1EYDCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:02:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40392 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1EYDCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:02:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDC712C.8090509@jp.fujitsu.com>
Date: Wed, 25 May 2011 12:02:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com
Subject: [PATCH 1/3] swap-token: fix dead link
References: <4DD480DD.2040307@jp.fujitsu.com>	<4DD481A7.3050108@jp.fujitsu.com> <20110520123004.e81c932e.akpm@linux-foundation.org> <4DDB1388.2080102@jp.fujitsu.com>
In-Reply-To: <4DDB1388.2080102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.cs.wm.edu/~sjiang/token.pdf is now dead. Then, this patch
replace it with an alive alternative.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/thrash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/thrash.c b/mm/thrash.c
index af46d67..0d41ff0 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -6,7 +6,7 @@
  * Released under the GPL, see the file COPYING for details.
  *
  * Simple token based thrashing protection, using the algorithm
- * described in:  http://www.cs.wm.edu/~sjiang/token.pdf
+ * described in: http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/abs05-1.html
  *
  * Sep 2006, Ashwin Chaugule <ashwin.chaugule@celunite.com>
  * Improved algorithm to pass token:
-- 
1.7.3.1



