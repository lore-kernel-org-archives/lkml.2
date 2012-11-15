Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2KOAsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:48:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63614 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2KOAsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:48:00 -0500
Date: Wed, 14 Nov 2012 16:47:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 0/7] fixups for kmemcg
In-Reply-To: <1352948093-2315-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1211141647410.482@chino.kir.corp.google.com>
References: <1352948093-2315-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Glauber Costa wrote:

> Andrew,
> 
> As you requested, here are some fixups and clarifications for the kmemcg series.
> It also handles one bug reported by Sasha.
> 

On the series:
Acked-by: David Rientjes <rientjes@google.com>
