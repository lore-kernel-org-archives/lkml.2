Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2FKVkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:40:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2FKVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:40:13 -0400
Date: Mon, 11 Jun 2012 14:40:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: clean up __count_immobile_pages
Message-Id: <20120611144011.60fd76c8.akpm@linux-foundation.org>
In-Reply-To: <1339380442-1137-1-git-send-email-minchan@kernel.org>
References: <1339380442-1137-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 11:07:22 +0900
Minchan Kim <minchan@kernel.org> wrote:

> __count_immobile_pages naming is rather awkward.
> This patch clean up the function and add comment.

This conflicts with
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
and its fixes.

> + * This function can race in PageLRU and MIGRATE_MOVABLE can have unmovable
> + * pages so that it might be not exact.

I don't understand this.  Functions race against other functions, not
against a page flag.  Can we have another attempt at this description
please?

