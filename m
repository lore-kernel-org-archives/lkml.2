Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab2FUJu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:50:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198Ab2FUJu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:50:26 -0400
Date: Thu, 21 Jun 2012 11:50:24 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: Bad rss-counter state
Message-ID: <20120621095024.GA10745@tiehlicka.suse.cz>
References: <20120620194908.GA16353@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620194908.GA16353@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-06-12 15:49:08, Nick Bowler wrote:
> Hi folks,
> 
> I just noticed the following couple lines in my kernel log for Linux
> 3.4.2:
> 
>   Jun 20 14:57:54 emergent kernel: BUG: Bad rss-counter state mm:ffff88000ff1f400 idx:1 val:-2
>   Jun 20 14:57:54 emergent kernel: BUG: Bad rss-counter state mm:ffff88000ff1f400 idx:2 val:2
> 
> I have no idea what these messages mean, nor what I was doing exactly
> at 14:57:54 today, nor whether they've been fixed in newer kernels.
> Regardless, they appear to be telling me that there's a kernel problem
> since they contain the word "BUG", so I figured I had better report them
> nonetheless.  Other than the fact that these messages were printed, the
> system is operating normally.

The issue is known and the fix can be found at
https://lkml.org/lkml/2012/6/9/47
 
> This happened about a week after bootup, so it's probably not easy to
> reproduce.
> 
> Let me know if you need any more info,
> -- 
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
