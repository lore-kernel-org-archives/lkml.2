Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab2FQBxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 21:53:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38526 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2FQBxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 21:53:04 -0400
Date: Sat, 16 Jun 2012 18:53:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wanpeng Li <liwp.linux@gmail.com>
cc: linux-mm@kvack.org, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/vmscan: cleanup comment error in balance_pgdat
In-Reply-To: <1339896438-5412-1-git-send-email-liwp.linux@gmail.com>
Message-ID: <alpine.DEB.2.00.1206161852010.797@chino.kir.corp.google.com>
References: <1339896438-5412-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012, Wanpeng Li wrote:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

I think it would be better to do per-subsystem audits like this in a 
single patch, i.e. one patch for mm/*, one patch for net/*, etc, get it 
acked, and then ask for it to be merged after an -rc1 release to avoid 
lots of conflicts with other people's work.
