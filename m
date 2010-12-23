Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0LWIbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:31:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:17765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0LWIbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:31:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="871219559"
Subject: Re: [RFC -v9 4/4] net, rds, Replace xlist in net/rds/xlist.h with
 llist
From: Huang Ying <ying.huang@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <25219.1293087917@localhost>
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
	 <1293083003-19577-5-git-send-email-ying.huang@intel.com>
	 <25219.1293087917@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 16:31:47 +0800
Message-ID: <1293093107.8743.181.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
On Thu, 2010-12-23 at 15:05 +0800, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 23 Dec 2010 13:43:23 +0800, Huang Ying said:
> > The functionality of xlist and llist is almost same.  This patch
> > replace xlist with llist to avoid code duplication.
> 
> >  /*
> > - * this takes a list head of mrs and turns it into an xlist of clusters.
> > - * each cluster has an xlist of MR_CLUSTER_SIZE mrs that are ready for
> > - * reuse.
> > + * this takes a list head of mrs and turns it into linked llist nodes.
> >   */
> 
> This comment change loses a lot of information.  The original 3 lines
> tells me a lot about what the data structure is and what it's used for,
> the replacement is a 'b +=5; /* add 5 to b */' type of comment.

Sorry, maybe I misunderstand the comments and code.  From comments I
imagine the result is a two-dimension lock-less list, but from the code
I only find an one-dimension lock-less list.  Is it?

Best Regards,
Huang Ying


