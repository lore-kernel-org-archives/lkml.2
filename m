Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1ADBuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:50:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54642 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1ADBuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:50:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Jan 2011 10:44:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/7] Good bye remove_from_page_cache
Message-Id: <20110104104428.d3ff3aca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <3733d2c036b930eba792e12c824516c04988556e.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
	<3733d2c036b930eba792e12c824516c04988556e.1293982522.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Jan 2011 00:44:35 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Now delete_from_page_cache replaces remove_from_page_cache.
> So we remove remove_from_page_cache so fs or something out of
> mainline will notice it when compile time and can fix it.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Acked-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

