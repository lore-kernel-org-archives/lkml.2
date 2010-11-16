Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab0KPEIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:08:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab0KPEIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:08:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 13:02:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: fix unit mismatch in memcg oom limit calculation
Message-Id: <20101116130240.92986f01.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101109110521.GS23393@cmpxchg.org>
References: <20101109110521.GS23393@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 12:05:21 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Adding the number of swap pages to the byte limit of a memory control
> group makes no sense.  Convert the pages to bytes before adding them.
> 
> The only user of this code is the OOM killer, and the way it is used
> means that the error results in a higher OOM badness value.  Since the
> cgroup limit is the same for all tasks in the cgroup, the error should
> have no practical impact at the moment.
> 
> But let's not wait for future or changing users to trip over it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


