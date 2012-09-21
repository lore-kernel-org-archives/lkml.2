Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2IUJkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:40:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41537 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab2IUJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <1347977530-29755-1-git-send-email-glommer@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Date: Fri, 21 Sep 2012 12:40:15 +0300
X-Google-Sender-Auth: j84yoOVbVzIQ2txKlEAzIzkFqLg
Message-ID: <CAOJsxLFVMYUxoVOcaCAtvwZmyMHS9mB3msP8gHn0a6NqzneLqQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Glauber,

On Tue, Sep 18, 2012 at 5:11 PM, Glauber Costa <glommer@parallels.com> wrote:
> This is a followup to the previous kmem series. I divided them logically
> so it gets easier for reviewers. But I believe they are ready to be merged
> together (although we can do a two-pass merge if people would prefer)
>
> Throwaway git tree found at:
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git kmemcg-slab
>
> There are mostly bugfixes since last submission.

Overall, I like this series a lot. However, I don't really see this as a
v3.7 material because we already have largeish pending updates to the
slab allocators. I also haven't seen any performance numbers for this
which is a problem.

So what I'd really like to see is this series being merged early in the
v3.8 development cycle to maximize the number of people eyeballing the
code and looking at performance impact.

Does this sound reasonable to you Glauber?

                        Pekka
