Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab2DLLor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:44:47 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33013 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2DLLoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:44:46 -0400
Message-ID: <4F86BFC6.2050400@parallels.com>
Date: Thu, 12 Apr 2012 08:43:02 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com>
In-Reply-To: <20120412113217.GB11455@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.35.198.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 08:32 AM, Frederic Weisbecker wrote:
>> But I think increasing number of subsystem is not very good....
> If the result is a better granularity on the overhead, I believe this
> can be a good thing.

But again, since there is quite number of people trying to merge those 
stuff together, you are just swimming against the tide.

If this gets really integrated, out of a sudden the overhead will 
appear. So better care about it now.
