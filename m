Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031153Ab2CNWO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:14:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54669 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030915Ab2CNWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F608579.5090109@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	<1331325556-16447-7-git-send-email-ssouhlal@FreeBSD.org>
	<4F5C8414.5090800@parallels.com>
	<CABCjUKCioWO-F7k=hVs_18B3uyL4zG3-krPFDh++YAnmejKKdg@mail.gmail.com>
	<4F608579.5090109@parallels.com>
Date: Wed, 14 Mar 2012 15:08:13 -0700
Message-ID: <CABCjUKCktPzzZDXMRejDXGXtta=pH5LGHRGU-SjJPuYNkxjH0g@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] slab: Add kmem_cache_gfp_flags() helper function.
From: Suleiman Souhlal <suleiman@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, cl@linux.com,
        yinghan@google.com, hughd@google.com, gthelen@google.com,
        peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org,
        mgorman@suse.de, James.Bottomley@hansenpartnership.com,
        linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 4:48 AM, Glauber Costa <glommer@parallels.com> wrote:
> So what?
> That function is only called from slab.c anyway. Let slab call it
> mem_cgroup_get_kmem_cache(cachep, flags | cachep->allocflags);
> and slub
> mem_cgroup_get_kmem_cache(cachep, flags | cachep->gfpflags);

Ok, I will do that.
I felt like it was better to do it in a single place, instead of doing
it at all the callers.

-- Suleiman
