Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab0J2Hs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 03:48:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46713 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0J2Hsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 03:48:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 29 Oct 2010 16:43:17 +0900
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
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v4 10/11] memcg: add cgroupfs interface to memcg dirty
 limits
Message-Id: <20101029164317.3f9a0a0a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1288336154-23256-11-git-send-email-gthelen@google.com>
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
	<1288336154-23256-11-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 00:09:13 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add cgroupfs interface to memcg dirty page limits:
>   Direct write-out is controlled with:
>   - memory.dirty_ratio
>   - memory.dirty_limit_in_bytes
> 
>   Background write-out is controlled with:
>   - memory.dirty_background_ratio
>   - memory.dirty_background_limit_bytes
> 
> Other memcg cgroupfs files support 'M', 'm', 'k', 'K', 'g'
> and 'G' suffixes for byte counts.  This patch provides the
> same functionality for memory.dirty_limit_in_bytes and
> memory.dirty_background_limit_bytes.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

-Kame

