Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1GWMj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 08:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab1GWMjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 08:39:53 -0400
Date: Sat, 23 Jul 2011 14:39:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venki@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disable]
Message-ID: <20110723123950.GA30098@tiehlicka.suse.cz>
References: <20110722091151.GA4004@tiehlicka.suse.cz>
 <4E29A20C.70402@zytor.com>
 <20110722173102.GA26935@tiehlicka.suse.cz>
 <4E29C1DF.9080705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E29C1DF.9080705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-07-11 11:30:55, H. Peter Anvin wrote:
> On 07/22/2011 10:31 AM, Michal Hocko wrote:
> > 
> > Thanks for the clarification!
> > What do you think about fixing the nopat with STRICT_DEVMEM like the
> > patch does?
> > 
> 
> From what I gather from your patch, the issue is that STRICT_DEVMEM
> isn't being honored with nopat?

Yes.

> This is an obvious bug and should be fixed.

OK, thanks for confirmation. Should I just repost the patch without the
question about PAT vs. /dev/[k]mem or you will just pick it up from
there? Or would you preffer a different fix?

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
