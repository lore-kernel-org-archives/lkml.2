Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2GaQal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:30:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33272 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2GaQaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:30:39 -0400
Date: Tue, 31 Jul 2012 18:30:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        devel@openvz.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 00/10] memcg kmem limitation - slab.
Message-ID: <20120731163027.GE17078@somewhere.redhat.com>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343227101-14217-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 06:38:11PM +0400, Glauber Costa wrote:
> Hi,
> 
> This is the slab part of the kmem limitation mechanism in its last form.  I
> would like to have comments on it to see if we can agree in its form. I
> consider it mature, since it doesn't change much in essence over the last
> forms. However, I would still prefer to defer merging it and merge the
> stack-only patchset first (even if inside the same merge window). That patchset
> contains most of the infrastructure needed here, and merging them separately
> would not only reduce the complexity for reviewers, but allow us a chance to
> have independent testing on them both. I would also likely benefit from some
> extra testing, to make sure the recent changes didn't introduce anything bad.

What is the status of the stack-only limitation patchset BTW? Does anybody oppose
to its merging?

Thanks.
