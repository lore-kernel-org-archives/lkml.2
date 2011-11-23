Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1KWWfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:35:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1KWWfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:35:54 -0500
Date: Wed, 23 Nov 2011 14:35:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] mm: oom_kill: remove memcg argument from
 oom_kill_task()
In-Reply-To: <1322062951-1756-2-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.DEB.2.00.1111231435400.5261@chino.kir.corp.google.com>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org> <1322062951-1756-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Johannes Weiner wrote:

> From: Johannes Weiner <jweiner@redhat.com>
> 
> The memcg argument of oom_kill_task() hasn't been used since 341aea2
> 'oom-kill: remove boost_dying_task_prio()'.  Kill it.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
