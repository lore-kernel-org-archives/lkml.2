Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab1ADBvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:51:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38335 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1ADBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:51:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Jan 2011 10:45:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 7/7] Change __remove_from_page_cache
Message-Id: <20110104104517.e55410b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <593ce6375438dfa3299ccbc5011a8dfc983340fb.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
	<593ce6375438dfa3299ccbc5011a8dfc983340fb.1293982522.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Jan 2011 00:44:36 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Now we renamed remove_from_page_cache with delete_from_page_cache.
> As consistency of __remove_from_swap_cache and remove_from_swap_cache,
> We change internal page cache handling function name, too.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Acked-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

