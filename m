Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0K2Khi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:37:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:60000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0K2Khg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:37:36 -0500
Date: Mon, 29 Nov 2010 11:37:34 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: stable@kernel.org, vegard.nossum@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, eugene@redhat.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] af_unix: limit unix_tot_inflight
Message-ID: <20101129103734.GA11071@tiehlicka.suse.cz>
References: <1290553918.2866.80.camel@edumazet-laptop>
 <1290590335.3464.24.camel@edumazet-laptop>
 <20101126085000.GA4532@tiehlicka.suse.cz>
 <20101126.182714.226785459.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126.182714.226785459.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 26-11-10 18:27:14, David Miller wrote:
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 26 Nov 2010 09:50:00 +0100
> 
> > Shouldn't this go to stable?
> > AFAICS 2.6.32 contains the same code (the patch applies). 
> > I haven't tried to reproduce the issue yet.
> 
> I'll submit it to all the stable branches after this patch (and the
> other AF_UNIX fixes recently proposed) have sat in Linus's tree for at
> least half a week or so.

OK, thanks!

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
