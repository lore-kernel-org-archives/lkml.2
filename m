Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2CMUse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:48:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2CMUsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:48:31 -0400
Date: Tue, 13 Mar 2012 13:48:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] page_alloc.c: kill add_from_early_node_map
In-Reply-To: <1331652720-3054-1-git-send-email-consul.kautuk@gmail.com>
Message-ID: <alpine.DEB.2.00.1203131348160.27008@chino.kir.corp.google.com>
References: <1331652720-3054-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Kautuk Consul wrote:

> No one seems to be calling add_from_early_node_map anywhere from the
> kernel.
> 
> Also, deleting this function decreases page_alloc.o file size.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
