Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab0KPDr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:47:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49697 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0KPDr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:47:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 12:41:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] memcg: break out event counters from other stats
Message-Id: <20101116124151.4830f685.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101107220353.684449249@cmpxchg.org>
References: <20101107215030.007259800@cmpxchg.org>
	<20101107220353.684449249@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Nov 2010 23:14:38 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> For increasing and decreasing per-cpu cgroup usage counters it makes
> sense to use signed types, as single per-cpu values might go negative
> during updates.  But this is not the case for only-ever-increasing
> event counters.
> 
> All the counters have been signed 64-bit so far, which was enough to
> count events even with the sign bit wasted.
> 
> The next patch narrows the usage counters type (on 32-bit CPUs, that
> is), though, so break out the event counters and make them unsigned
> words as they should have been from the start.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

