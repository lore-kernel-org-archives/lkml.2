Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab0KVGkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 01:40:53 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51604 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0KVGkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 01:40:52 -0500
Date: Mon, 22 Nov 2010 12:10:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] memcg: add mem_cgroup parameter to
 mem_cgroup_page_stat()
Message-ID: <20101122064043.GI12043@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
 <1289294671-6865-2-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1289294671-6865-2-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-11-09 01:24:26]:

> This new parameter can be used to query dirty memory usage
> from a given memcg rather than the current task's memcg.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
>

How is this useful, documenting that in the changelog would be nice. 

-- 
	Three Cheers,
	Balbir
