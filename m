Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315Ab2IGJsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:48:32 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49618 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760239Ab2IGJsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:48:30 -0400
Message-ID: <5049C221.4030003@parallels.com>
Date: Fri, 7 Sep 2012 13:45:05 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
References: <20120904143552.GB15683@dhcp22.suse.cz> <50461241.5010300@parallels.com> <20120904145414.GC15683@dhcp22.suse.cz> <50461610.30305@parallels.com> <20120904162501.GE15683@dhcp22.suse.cz> <504709D4.2010800@parallels.com> <20120905144942.GH5388@dhcp22.suse.cz> <20120905201238.GE13737@google.com> <20120906120623.GE22426@dhcp22.suse.cz> <50489270.7060108@parallels.com> <20120906121842.GG22426@dhcp22.suse.cz>
In-Reply-To: <20120906121842.GG22426@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 04:18 PM, Michal Hocko wrote:
>> Just so I understand it:
>> > 
>> > Michal clearly objected before folding his patch with my Kconfig patch.
>> > But is there still opposition to merge both?
> I do not find the config option very much useful but if others feel it
> really is I won't block it.
> 
Tejun, what is your take on this?
