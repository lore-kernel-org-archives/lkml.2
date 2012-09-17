Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2IQRag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:30:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab2IQRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:30:30 -0400
Date: Mon, 17 Sep 2012 10:30:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120917173024.GC18677@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
 <20120914185324.GI17747@google.com>
 <20120914192840.GG6221@redhat.com>
 <20120914194439.GP17747@google.com>
 <20120914194950.GQ17747@google.com>
 <20120914203925.GR17747@google.com>
 <5056E1FC.1090508@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5056E1FC.1090508@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:40:28PM +0400, Glauber Costa wrote:
> That is exactly what I proposed in our previous discussions around
> memcg, with files like "available_controllers" , "current_controllers".
> Name chosen to match what other subsystems already do.
> 
> if memcg is not in "available_controllers" for a node, it cannot be seen
> by anyone bellow that level.

Glauber, I was talking about making the switch applicable from the
current level *INSTEAD OF* anyone below the current level, so that we
don't have to apply the same switch on all siblings.  I have no idea
why this is causing so much miscommunication. :(

-- 
tejun
