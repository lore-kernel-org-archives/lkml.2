Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1GZPTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:19:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab1GZPTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:19:12 -0400
Date: Tue, 26 Jul 2011 17:19:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, lacombar@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 2/2] mm: Switch NUMA_BUILD and COMPACTION_BUILD to
 new KCONFIG() syntax
Message-ID: <20110726151908.GD17958@tiehlicka.suse.cz>
References: <4E1D9C25.8080300@suse.cz>
 <1311634718-32588-1-git-send-email-mmarek@suse.cz>
 <1311634718-32588-2-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311634718-32588-2-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-07-11 00:58:38, Michal Marek wrote:
> Cc: linux-mm@kvack.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>

I assume that this is a cleanup. Without seeing the rest of the patch
set (probably not in linux-mm missing in the CC) and the cover email it
is hard to be sure. Could you add some description to the patch, please?

> ---
>  include/linux/gfp.h    |    2 +-
>  include/linux/kernel.h |   14 --------------
>  mm/page_alloc.c        |   12 ++++++------
>  mm/vmalloc.c           |    4 ++--
>  mm/vmscan.c            |    2 +-
>  5 files changed, 10 insertions(+), 24 deletions(-)

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
