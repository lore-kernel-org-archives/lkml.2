Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1KXGJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:09:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63806 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1KXGJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Date: Thu, 24 Nov 2011 11:39:39 +0530
Message-ID: <CAKTCnzk0Jzq+o1Qv9hOO5ssO7U_xe1ZqUaWDhWEeJAQQPjPudg@mail.gmail.com>
Subject: Re: [patch 0/8] mm: memcg fixlets for 3.3
From: Balbir Singh <bsingharora@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Here are some minor memcg-related cleanups and optimizations, nothing
> too exciting.  The bulk of the diffstat comes from renaming the
> remaining variables to describe a (struct mem_cgroup *) to "memcg".
> The rest cuts down on the (un)charge fastpaths, as people start to get
> annoyed by those functions showing up in the profiles of their their
> non-memcg workloads.  More is to come, but I wanted to get the more
> obvious bits out of the way.

Hi, Johannes

The renaming was a separate patch sent from Raghavendra as well, not
sure if you've seen it. What tests are you using to test these
patches?

Balbir
