Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2EYJam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:30:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:13985 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab2EYJai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:30:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171238698"
Date: Fri, 25 May 2012 17:29:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 v4] Flexible proportions
Message-ID: <20120525092936.GA12729@localhost>
References: <1337878751-22942-1-git-send-email-jack@suse.cz>
 <1337937162.9783.163.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337937162.9783.163.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 11:12:42AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-24 at 18:59 +0200, Jan Kara wrote:
> >   here is the next iteration of my flexible proportions code. I've addressed
> > all Peter's comments. 
> 
> Thanks, all I could come up with is comment placement nits and I'll not
> go there ;-)
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thank you both for making it work!  I've applied them to the writeback tree.

Thanks,
Fengguang
