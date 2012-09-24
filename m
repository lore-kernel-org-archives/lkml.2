Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2IXPiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:38:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58430 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab2IXPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <506066E3.6050705@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-6-git-send-email-glommer@parallels.com>
	<20120921181458.GG7264@google.com>
	<506015E7.8030900@parallels.com>
	<00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
	<50605500.5050606@parallels.com>
	<00000139f8836571-6ddc9d5b-1d5f-4542-92f9-ad11070e5b7d-000000@email.amazonses.com>
	<506063B8.70305@parallels.com>
	<00000139f890a302-980aee84-40b2-433f-8dbd-e7b1d219f00d-000000@email.amazonses.com>
	<506066E3.6050705@parallels.com>
Date: Mon, 24 Sep 2012 18:38:48 +0300
X-Google-Sender-Auth: 5cBhFeJfcGil568E5JXRJYInX3o
Message-ID: <CAOJsxLGFWQFNUUN3sDeB2sn0S-QM-6Ut_d02HjmF6mB5aMytoA@mail.gmail.com>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in kmem_create_cache
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<cgroups@vger.kernel.org>" <cgroups@vger.kernel.org>,
        "<kamezawa.hiroyu@jp.fujitsu.com>" <kamezawa.hiroyu@jp.fujitsu.com>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "<linux-mm@kvack.org>" <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:56 PM, Christoph Lameter wrote:
>> On Mon, 24 Sep 2012, Glauber Costa wrote:
>>
>>> The reason I say it is orthogonal, is that people will still want to see
>>> their caches in /proc/slabinfo, regardless of wherever else they'll be.
>>> It was a requirement from Pekka in one of the first times I posted this,
>>> IIRC.
>>
>> They want to see total counts there true. But as I said we already have a
>> duplication of the statistics otherwise. We have never done the scheme
>> that you propose. That is unexpected. I would not expect the numbers to be
>> there.

On Mon, Sep 24, 2012 at 4:57 PM, Glauber Costa <glommer@parallels.com> wrote:
> I myself personally believe it can potentially clutter slabinfo, and
> won't put my energy in defending the current implementation. What I
> don't want is to keep switching between implementations.
>
> Pekka, Tejun, what do you guys say here?

So Christoph is proposing that the new caches appear somewhere under
the cgroups directory and /proc/slabinfo includes aggregated counts,
right? I'm certainly OK with that.
