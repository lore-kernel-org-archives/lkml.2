Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2IZRof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:44:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35688 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2IZRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <50633D24.6020002@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
	<1347977050-29476-5-git-send-email-glommer@parallels.com>
	<20120926140347.GD15801@dhcp22.suse.cz>
	<20120926163648.GO16296@google.com>
	<50633D24.6020002@parallels.com>
Date: Wed, 26 Sep 2012 10:44:32 -0700
X-Google-Sender-Auth: 75kdb-bA9ZUScZLzrnc58nz2GHk
Message-ID: <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Sep 26, 2012 at 10:36 AM, Glauber Costa <glommer@parallels.com> wrote:
> This was discussed multiple times. Our interest is to preserve existing
> deployed setup, that were tuned in a world where kmem didn't exist.
> Because we also feed kmem to the user counter, this may very well
> disrupt their setup.

So, that can be served by .kmem_accounted at root, no?

> User memory, unlike kernel memory, may very well be totally in control
> of the userspace application, so it is not unreasonable to believe that
> extra pages appearing in a new kernel version may break them.
>
> It is actually a much worse compatibility problem than flipping
> hierarchy, in comparison

Again, what's wrong with one switch at the root?

Thanks.

-- 
tejun
