Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab1EMJkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:40:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36145 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab1EMJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:40:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 18:33:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH v7 04/14] memcg: add dirty page accounting
 infrastructure
Message-Id: <20110513183308.0c34201d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1305276473-14780-5-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
	<1305276473-14780-5-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 01:47:43 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add memcg routines to count dirty, writeback, and unstable_NFS pages.
> These routines are not yet used by the kernel to count such pages.  A
> later change adds kernel calls to these new routines.
> 
> As inode pages are marked dirty, if the dirtied page's cgroup differs
> from the inode's cgroup, then mark the inode shared across several
> cgroup.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


