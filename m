Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2B1APK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:15:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48421 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2B1APF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:15:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 09:13:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 03/21] memcg: fix page_referencies cgroup filter on
 global reclaim
Message-Id: <20120228091337.7d227a0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135151.12988.37646.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135151.12988.37646.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:51:51 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Global memory reclaimer shouldn't skip any page referencies.
> 
> This patch pass sc->target_mem_cgroup into page_referenced().
> On global memory reclaim it always NULL, so we will account all.
> Cgroup reclaimer will account only referencies from target cgroup and its childs.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

seems nice to me.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

