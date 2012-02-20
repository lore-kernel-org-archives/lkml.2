Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2BTIyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:54:31 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41247 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2BTIya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:54:30 -0500
Date: Mon, 20 Feb 2012 09:54:20 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 1/6] memcg: remove
 EXPORT_SYMBOL(mem_cgroup_update_page_stat)
Message-ID: <20120220085420.GA1677@cmpxchg.org>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
 <20120217182535.6a17ec72.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217182535.6a17ec72.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 06:25:35PM +0900, KAMEZAWA Hiroyuki wrote:
> >From 7075e575cc6ee383f8fd161ba44c44a60c295d5f Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 12:05:41 +0900
> Subject: [PATCH 1/6] memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)
> 
> >From the log, I guess EXPORT was for preparing dirty accounting.
> But _now_, we don't need to export this. Remove this for now.
> 
> Reviewed-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
