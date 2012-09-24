Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2IXITR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:19:17 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54976 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab2IXITQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:19:16 -0400
Message-ID: <506016B7.8010600@parallels.com>
Date: Mon, 24 Sep 2012 12:15:51 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <20120921204619.GR7264@google.com>
In-Reply-To: <20120921204619.GR7264@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 12:46 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 18, 2012 at 06:11:54PM +0400, Glauber Costa wrote:
>> This is a followup to the previous kmem series. I divided them logically
>> so it gets easier for reviewers. But I believe they are ready to be merged
>> together (although we can do a two-pass merge if people would prefer)
>>
>> Throwaway git tree found at:
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git kmemcg-slab
>>
>> There are mostly bugfixes since last submission.
>>
>> For a detailed explanation about this series, please refer to my previous post
>> (Subj: [PATCH v3 00/13] kmem controller for memcg.)
> 
> In general, things look good to me.  I think the basic approach is
> manageable and does a decent job of avoiding introducing complications
> on the usual code paths.
> 
> Pekka seems generally happy with the approach too.  Christoph, what do
> you think?
> 
> Thanks.
> 
I myself think that while the approach is okay, this would need one or
two more versions for us to sort out some issues that are still remaining.

I'd very much like to have the kmemcg-stack series seeing its way
forward first. Mel Gorman said he would try his best to review it his
week, and I don't plan to resubmit anything before that.

After that, I plan to rebase at least this one again.
