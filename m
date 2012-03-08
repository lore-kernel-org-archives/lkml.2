Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2CHBkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:40:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48061 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2CHBkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:40:07 -0500
Date: Wed, 7 Mar 2012 17:40:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] mm, counters: remove task argument to sync_mm_rss
 and __sync_task_rss_stat
In-Reply-To: <20120307171155.f9bb71b6.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1203071739150.26591@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com> <20120307171155.f9bb71b6.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Andrew Morton wrote:

> hm, with my gcc it's beneficial to cache `current' in a local.  But
> when I tried that, Weird Things happened, because gcc has gone and
> decided to inline __sync_task_rss_stat() into its callers.  I don't see
> how that could have been the right thing to do.
> 

c06b1fca18c3 offers some advice :)
