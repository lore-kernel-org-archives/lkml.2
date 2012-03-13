Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030256Ab2CMKNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:13:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43237 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204Ab2CMKNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:13:23 -0400
Message-ID: <4F5F1D67.10001@parallels.com>
Date: Tue, 13 Mar 2012 14:11:51 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com>  <20120312221050.GG23255@google.com> <1331590938.18960.57.camel@twins>  <20120312222817.GI23255@google.com> <1331591568.18960.61.camel@twins>  <20120312223944.GJ23255@google.com> <1331592241.18960.64.camel@twins>
In-Reply-To: <1331592241.18960.64.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 02:44 AM, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 15:39 -0700, Tejun Heo wrote:
>> >  If we can get to the point where nesting is fully
>> >  supported by every controller first, that would be awesome too.
> As long as that is the goal.. otherwise, I'd be overjoyed if I can rip
> nesting support out of the cpu-controller.. that stuff is such a pain.
> Then again, I don't think the container people like this proposal --
> they were the ones pushing for full hierarchy back when.

Indeed. At some point it is desirable that an admin inside the container 
be able to divide resources between the tasks they see.

Maybe it doesn't even make sense for things like I/O, for each he at 
most has an illusion of control anyway. But cpu is a lot more tangible 
resource in this regard.
