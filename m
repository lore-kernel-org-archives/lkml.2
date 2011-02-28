Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1B1CxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:53:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44449 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1B1CxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:53:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Feb 2011 11:46:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v5 7/9] memcg: add dirty limits to mem_cgroup
Message-Id: <20110228114649.af7fd716.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1298669760-26344-8-git-send-email-gthelen@google.com>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
	<1298669760-26344-8-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 13:35:58 -0800
Greg Thelen <gthelen@google.com> wrote:

> Extend mem_cgroup to contain dirty page limits.  Also add routines
> allowing the kernel to query the dirty usage of a memcg.
> 
> These interfaces not used by the kernel yet.  A subsequent commit
> will add kernel calls to utilize these new routines.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


