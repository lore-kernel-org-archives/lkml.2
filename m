Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2HOO5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:57:32 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:52721 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab2HOO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:57:31 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 10:57:30 EDT
Date: Wed, 15 Aug 2012 14:47:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
In-Reply-To: <20120815123931.GF23985@dhcp22.suse.cz>
Message-ID: <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Michal Hocko wrote:

> > That is not what the kernel does, in general. We assume that if he wants
> > that memory and we can serve it, we should. Also, not all kernel memory
> > is unreclaimable. We can shrink the slabs, for instance. Ying Han
> > claims she has patches for that already...
>
> Are those patches somewhere around?

You can already shrink the reclaimable slabs (dentries / inodes) via
calls to the subsystem specific shrinkers. Did Ying Han do anything to
go beyond that?

