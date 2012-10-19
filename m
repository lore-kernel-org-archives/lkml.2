Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2JSTeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:34:17 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:20419 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757107Ab2JSTeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:34:15 -0400
Date: Fri, 19 Oct 2012 19:34:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 04/18] slab: don't preemptively remove element from
 list in cache destroy
In-Reply-To: <1350656442-1523-5-git-send-email-glommer@parallels.com>
Message-ID: <0000013a7a84cb28-334eab12-33c4-4a92-bd9c-e5ad938f83d0-000000@email.amazonses.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-5-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Glauber Costa wrote:

> I, however, see no reason why we need to do so, since we are now locked
> during the whole deletion (which wasn't necessarily true before).  I
> propose a simplification in which we delete it only when there is no
> more going back, so we don't need to add it again.

Ok lets hope that holding the lock does not cause issues.

Acked-by: Christoph Lameter <cl@linux.com>
