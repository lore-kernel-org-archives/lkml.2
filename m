Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2IUJOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:14:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57588 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab2IUJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <505C2856.70900@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
	<1347977050-29476-7-git-send-email-glommer@parallels.com>
	<CAAmzW4ONnc7n3kZbYnE6n2Cg0ZyPXW0QU2NMr0uRkyTxnGpNqQ@mail.gmail.com>
	<505C2856.70900@parallels.com>
Date: Fri, 21 Sep 2012 18:14:10 +0900
Message-ID: <CAAmzW4MbqMevvxk1ibcogr2ED74kR2_46MRX=VO5dLLa4CZkAA@mail.gmail.com>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
From: JoonSoo Kim <js1304@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> "*_memcg = memcg" should be executed when "memcg_charge_kmem" is success.
>> "memcg_charge_kmem" return 0 if success in charging.
>> Therefore, I think this code is wrong.
>> If I am right, it is a serious bug that affect behavior of all the patchset.
>
> Which is precisely what it does. ret is a boolean, that will be true
> when charge succeeded (== 0 test)

Ahh...Okay! I didn't see (== 0 test)
