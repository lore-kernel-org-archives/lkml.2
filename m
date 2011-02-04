Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1BDAGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:06:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34230 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1BDAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:06:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 09:00:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: add memcg sanity checks at allocating and
 freeing pages
Message-Id: <20110204090008.20c9f049.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110203141533.GH2286@cmpxchg.org>
References: <20110203141533.GH2286@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 15:15:33 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> This patch add checks at allocating or freeing a page whether the page is used
> (iow, charged) from the view point of memcg.
> 
> This check may be useful in debugging a problem and we did similar checks
> before the commit 52d4b9ac(memcg: allocate all page_cgroup at boot).
> 
> This patch adds some overheads at allocating or freeing memory, so it's enabled
> only when CONFIG_DEBUG_VM is enabled.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


