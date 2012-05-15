Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992Ab2EOVzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:55:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40873 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab2EOVzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:55:07 -0400
Date: Tue, 15 May 2012 14:55:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 02/29] slub: fix slab_state for slub
In-Reply-To: <1336758272-24284-3-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205151453460.18595@chino.kir.corp.google.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-3-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> When the slub code wants to know if the sysfs state has already been
> initialized, it tests for slab_state == SYSFS. This is quite fragile,
> since new state can be added in the future (it is, in fact, for
> memcg caches). This patch fixes this behavior so the test matches
> >= SYSFS, as all other state does.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Acked-by: David Rientjes <rientjes@google.com>

Can be merged now, there's no dependency on the rest of this patchset.
