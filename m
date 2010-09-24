Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0IXJSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:18:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41329 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab0IXJSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:18:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Sep 2010 18:13:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/2] memcg: use ID instead of pointer in page_cgroup ,
 retry.
Message-Id: <20100924181302.7d764e0d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a reviced series of use ID.
Restart from RFC.

[1/2] implementation of special ID lookup
[2/2] use ID in mm/memcontrol.c

People may say use css_lookup() and don't add a special routine but
I can't believw css_lookup() can give us enough speed at every page LRU handling
if the number of cgroup is big. I think this patch itself is enough simple...
but I admit this will make mem_cgroup more complex. Hmm.

Thanks,
-Kame

