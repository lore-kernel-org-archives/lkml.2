Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2IGPMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:12:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2IGPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:12:48 -0400
Date: Fri, 7 Sep 2012 17:12:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: mmotm 2012-09-06-16-46 uploaded
Message-ID: <20120907151246.GB3688@dhcp22.suse.cz>
References: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Wu Fengguang so that he can update the link to the new tree
location]

On Thu 06-09-12 16:47:34, Andrew Morton wrote:
[...]
> A git tree which contains the memory management portion of this tree is
> maintained at https://github.com/mstsxfx/memcg-devel.git by Michal Hocko. 

I have finally added the tree to the kernel.org infrastructure
(http://git.kernel.org/?p=linux/kernel/git/mhocko/mm.git;a=summary).

Both (k.org and github) have the same branches and layout and I will be
updating both until the end of this month. Github will be discontinued
since 1st Oct.

The switch is really easy. Just add a new remote
$ git remote add mm git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git

and move your local tracking branches to point to the new remote.

> It contains the patches which are between the "#NEXT_PATCHES_START mm" and
> "#NEXT_PATCHES_END" markers, from the series file,
> http://www.ozlabs.org/~akpm/mmotm/series.
-- 
Michal Hocko
SUSE Labs
