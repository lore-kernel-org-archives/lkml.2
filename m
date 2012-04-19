Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2DSMug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:50:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab2DSMuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:50:35 -0400
Date: Thu, 19 Apr 2012 14:50:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120419125032.GB15634@tiehlicka.suse.cz>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
 <CAE9FiQXWKzv7Wo4iWGrKapmxQYtAGezghwup1UKoW2ghqUSr+A@mail.gmail.com>
 <20120417173203.GA32482@tiehlicka.suse.cz>
 <CAE9FiQXvZ4eSCwMSG2H7CC6suQe37TmQpmOEKW_082W3zz-6Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXvZ4eSCwMSG2H7CC6suQe37TmQpmOEKW_082W3zz-6Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-04-12 11:07:10, Yinghai Lu wrote:
> On Tue, Apr 17, 2012 at 10:32 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Tue 17-04-12 10:12:30, Yinghai Lu wrote:
> >>
> >> We are not using bootmem with x86 now, so could remove those workaround now.
> >
> > Could you be more specific about what the workaround is used for?
> 
> Don't bootmem allocating too low to use up all low memory. like for
> system with lots of memory for sparse vmemmap.

OK I see. Thanks for clarification.
I guess it doesn't make much sense to fix this particular thing now and
rather let it to a bigger clean up. If people think otherwise I can send
a patch though.


> 
> when nobootmem.c is used, __alloc_bootmem_node_high is the same as
> __alloc_bootmem_node.
> 
> Thanks
> 
> Yinghai
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
