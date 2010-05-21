Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0EUBnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:43:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44972 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab0EUBnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:43:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first
Cc: kosaki.motohiro@jp.fujitsu.com, Shaohua Li <shaohua.li@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com>
References: <20100519174327.9591.A69D9226@jp.fujitsu.com> <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com>
Message-Id: <20100521103935.1E56.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 21 May 2010 10:43:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Acked-by: Hugh Dickins <hughd@google.com>
> 
> Thanks - though I don't quite agree with your description: I can't
> see why the lru_cache_add_active_anon() was ever justified - that
> "active" came in along with the separate anon and file LRU lists.

If you have any worry, can you please share it? I'll test such workload
and fix the issue if necessary. You are expert than me in this area.



