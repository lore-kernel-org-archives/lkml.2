Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2CUAcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:32:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47612 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2CUAcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:32:31 -0400
Date: Wed, 21 Mar 2012 09:32:22 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] page_alloc.c: kill add_from_early_node_map
Message-ID: <20120321003222.GB14584@barrios>
References: <1331652720-3054-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331652720-3054-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:32:00AM -0400, Kautuk Consul wrote:
> No one seems to be calling add_from_early_node_map anywhere from the
> kernel.
> 
> Also, deleting this function decreases page_alloc.o file size.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Reviewed-by: Minchan Kim <minchan@kernel.org>
