Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1KXL6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:58:33 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42261 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1KXL6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:58:31 -0500
Date: Thu, 24 Nov 2011 12:58:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/8] mm: memcg: remove unneeded checks from
 newpage_charge()
Message-ID: <20111124115816.GA1225@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-6-git-send-email-hannes@cmpxchg.org>
 <20111124090443.d3f720c5.kamezawa.hiroyu@jp.fujitsu.com>
 <20111124090409.GC6843@cmpxchg.org>
 <20111124103049.GG26036@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124103049.GG26036@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:30:49AM +0100, Michal Hocko wrote:
> On Thu 24-11-11 10:04:09, Johannes Weiner wrote:
> > From: Johannes Weiner <jweiner@redhat.com>
> > Subject: mm: memcg: remove unneeded checks from newpage_charge() fix
> > 
> > Document page state assumptions and catch if they are violated in
> > newpage_charge().
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> I assume you are going to fold it into the previous one.
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks.

I'm under the assumption that incremental patches are better for
Andrew, but I forgot why.

But yes, this should be folded before going upstream.
