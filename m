Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751Ab2FVJXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:23:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199Ab2FVJX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:23:29 -0400
Date: Fri, 22 Jun 2012 11:23:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2012-06-21-16-20 uploaded
Message-ID: <20120622092327.GA5742@tiehlicka.suse.cz>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-06-12 16:21:49, Andrew Morton wrote:
> The mm-of-the-moment snapshot 2012-06-21-16-20 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/

And from now on, memcg-devel tree[1] will not only pick up memcg
relevant patches but all patches in the mm section.
The tree was mainly focused on memcg development in the past but it
seems that having all mm and memcg patches together would be much easier
and also non memcg developers could benefit from it.

The tree will not be rebased (unlike linux-next) and after Linus
releases X.Y a new branch (since-X.Y) will be created and the current
stack rebased on top of vX.Y tag. Old branches stay at the place.

Please note that the tree doesn't substitute mmotm and all the changes
still fly through Andrew. The sole purpose of the tree is to make git
worklows for -mm development easier.

Thanks Andrew for helping me with this and tweaking his series file to
make it as much automated as possible.

---
[1] https://github.com/mstsxfx/memcg-devel.git

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
