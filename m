Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2KZTJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:09:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab2KZTJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:09:30 -0500
Date: Mon, 26 Nov 2012 19:09:26 +0000
From: Mel Gorman <mgorman@suse.de>
To: George Spelvin <linux@horizon.com>
Cc: hannes@cmpxchg.org, dave@linux.vnet.ibm.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Message-ID: <20121126190926.GM8218@suse.de>
References: <20121126183242.GA9894@cmpxchg.org>
 <20121126185317.10879.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121126185317.10879.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 01:53:17PM -0500, George Spelvin wrote:
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> > Any chance you could test with this fix instead, in addition to Dave's
> > accounting fix?  It's got bool and everything!
> 
> Okay.  Mel, speak up if you object.  I also rebased on top of 3.7-rc7,
> which already includes Dave's fix.  Again, speak up if that's a bad idea.
> 

No objections all round.

-- 
Mel Gorman
SUSE Labs
