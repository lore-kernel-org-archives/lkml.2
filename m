Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab2INS4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:56:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35162 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab2INS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:56:51 -0400
Date: Fri, 14 Sep 2012 11:56:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120914185646.GK17747@google.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <50505C39.1050600@parallels.com>
 <20120912170933.GO7677@google.com>
 <5051CBAA.5040308@parallels.com>
 <20120913175401.GC7677@google.com>
 <5052E931.8000007@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052E931.8000007@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:22:09PM +0400, Glauber Costa wrote:
> This is not about being interested anymore
> This thing is more pressing than global warming.

Heh, yeah, let's save the polar bears. :)

-- 
tejun
