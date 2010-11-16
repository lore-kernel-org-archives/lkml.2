Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab0KPDwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:52:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56920 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab0KPDwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:52:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 12:47:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: avoid "free" overflow in
 memcg_hierarchical_free_pages()
Message-Id: <20101116124704.c68288b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1289292853-7022-1-git-send-email-gthelen@google.com>
References: <1289292853-7022-1-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Nov 2010 00:54:13 -0800
Greg Thelen <gthelen@google.com> wrote:

> memcg limit and usage values are stored in res_counter, as 64-bit
> numbers, even on 32-bit machines.  The "free" variable in
> memcg_hierarchical_free_pages() stores the difference between two
> 64-bit numbers (limit - current_usage), and thus should be stored
> in a 64-bit local rather than a machine defined unsigned long.
> 
> Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

