Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2IDO53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:57:29 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46622 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab2IDO52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:57:28 -0400
Message-ID: <50461610.30305@parallels.com>
Date: Tue, 4 Sep 2012 18:54:08 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903170806.GA21682@dhcp22.suse.cz> <5045BD25.10301@parallels.com> <20120904130905.GA15683@dhcp22.suse.cz> <504601B8.2050907@parallels.com> <20120904143552.GB15683@dhcp22.suse.cz> <50461241.5010300@parallels.com> <20120904145414.GC15683@dhcp22.suse.cz>
In-Reply-To: <20120904145414.GC15683@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I believe it would be really great to have a way to turn the default
>> to 1 - and stop the shouting.
> 
> We already can. You can use /etc/cgconfig (if you are using libcgroup)
> or do it manually.
> 
>> Even if you are doing it in OpenSUSE as a patch, an upstream patch means
>> at least that every distribution is using the same patch, and those who
>> rebase will just flip the config.
>>
>> I'd personally believe merging both our patches together would achieve a
>> good result.
> 
> I am still not sure we want to add a config option for something that is
> meant to go away. But let's see what others think.
> 

So what you propose in the end is that we add a userspace tweak for
something that could go away, instead of a Kconfig for something that go
away.

Way I see it, Kconfig is better because it is totally transparent, under
the hood, and will give us a single location to unpatch in case/when it
really goes away.


