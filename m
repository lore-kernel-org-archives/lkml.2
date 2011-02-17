Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1BQGbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 01:31:18 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60225 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1BQGbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 01:31:15 -0500
Date: Thu, 17 Feb 2011 12:01:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] memcg: break out event counters from other stats
Message-ID: <20110217063106.GI3415@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1297920842-17299-1-git-send-email-gthelen@google.com>
 <1297920842-17299-2-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1297920842-17299-2-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2011-02-16 21:34:01]:

> From: Johannes Weiner <hannes@cmpxchg.org>
> 
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
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Three Cheers,
	Balbir
