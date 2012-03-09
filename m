Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2CIKVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:21:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:36206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2CIKVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:21:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126930684"
Message-ID: <1331288661.22872.53.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 5/9] writeback: introduce the pageout work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 09 Mar 2012 12:24:21 +0200
In-Reply-To: <20120309095135.GC21038@quack.suse.cz>
References: <20120228160403.9c9fa4dc.akpm@linux-foundation.org>
	 <20120301123640.GA30369@localhost> <20120301163837.GA13104@quack.suse.cz>
	 <20120302044858.GA14802@localhost> <20120302095910.GB1744@quack.suse.cz>
	 <20120302103951.GA13378@localhost>
	 <20120302115700.7d970497.akpm@linux-foundation.org>
	 <20120303135558.GA9869@localhost>
	 <1331135301.32316.29.camel@sauron.fi.intel.com>
	 <20120309073113.GA5337@localhost> <20120309095135.GC21038@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 10:51 +0100, Jan Kara wrote:
> > However I cannot find any ubifs functions to form the above loop, so
> > ubifs should be safe for now.
>   Yeah, me neither but I also failed to find a place where
> ubifs_evict_inode() truncates inode space when deleting the inode... Artem?

evict_inode() stuff was introduced by Al relatively recently and I did
not even look at what it does, so I do not know what to answer. I'll
look at this and and answer.

-- 
Best Regards,
Artem Bityutskiy

