Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1HKNBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:01:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab1HKNBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:01:11 -0400
Date: Thu, 11 Aug 2011 15:01:10 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Switch NUMA_BUILD and COMPACTION_BUILD to new
 IS_ENABLED() syntax
Message-ID: <20110811130110.GK8023@tiehlicka.suse.cz>
References: <1312989160-737-1-git-send-email-mmarek@suse.cz>
 <20110811125133.GJ8023@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811125133.GJ8023@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-08-11 14:51:33, Michal Hocko wrote:
> On Wed 10-08-11 17:12:40, Michal Marek wrote:
> > Introduced in 3.1-rc1, IS_ENABLED(CONFIG_NUMA) expands to a true value
> > iff CONFIG_NUMA is set. This makes it easier to grep for code that
> > depends on CONFIG_NUMA.

I have just looked closer at all available macros. Wouldn't it make more
sense to use IS_BUILTIN instead? Both symbols can be only on or off.
Not that it would make any difference in the end. I even like IS_ENABLED
naming more.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
