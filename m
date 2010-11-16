Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab0KPEGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:06:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab0KPEGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:06:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 13:00:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] memcg: make mem_cgroup_page_stat() return value
 unsigned
Message-Id: <20101116130028.b68272e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1289294671-6865-7-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-7-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Nov 2010 01:24:31 -0800
Greg Thelen <gthelen@google.com> wrote:

> mem_cgroup_page_stat() used to return a negative page count
> value to indicate value.
> 
> mem_cgroup_page_stat() has changed so it never returns
> error so convert the return value to the traditional page
> count type (unsigned long).
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Okay.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

