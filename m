Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1HRBXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 21:23:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38004 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1HRBXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 21:23:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 10:15:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 10/13] writeback: pass wb_writeback_work into
 move_expired_inodes()
Message-Id: <20110818101538.9a679fcf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1313597705-6093-11-git-send-email-gthelen@google.com>
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
	<1313597705-6093-11-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 09:15:02 -0700
Greg Thelen <gthelen@google.com> wrote:

> A later change to move_expired_inodes() requires passing fields from
> writeback work descriptor into memcontrol code when determining if an
> inode should be written back considered.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

