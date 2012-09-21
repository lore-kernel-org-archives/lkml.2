Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2IUUre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:47:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab2IUUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:47:32 -0400
Date: Fri, 21 Sep 2012 13:47:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
Message-ID: <20120921204727.GS7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <20120921204619.GR7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921204619.GR7264@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:46:19PM -0700, Tejun Heo wrote:
> In general, things look good to me.  I think the basic approach is
> manageable and does a decent job of avoiding introducing complications
> on the usual code paths.
> 
> Pekka seems generally happy with the approach too.  Christoph, what do
> you think?

Ooh, also, why aren't Andrew and Michal not cc'd?

-- 
tejun
