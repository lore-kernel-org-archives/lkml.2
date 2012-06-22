Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683Ab2FVUTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:19:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2FVUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:19:03 -0400
Date: Fri, 22 Jun 2012 13:19:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds
 pages to the buddy allocator again
Message-Id: <20120622131901.28f273e3.akpm@linux-foundation.org>
In-Reply-To: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 12:16:10 -0400
kosaki.motohiro@gmail.com wrote:

> commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
> to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
> another miuse still exist.

This changelog is irritating.  One can understand it a bit if one
happens to have a git repo handy (and why do this to the reader?), but
the changelog for 2ff754fa8f indicates that the patch might fix a
livelock.  Is that true of this patch?  Who knows...
