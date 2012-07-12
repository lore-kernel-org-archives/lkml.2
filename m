Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab2GLVNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:13:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab2GLVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:13:44 -0400
Date: Thu, 12 Jul 2012 14:13:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 -mm] memcg: prevent from OOM with too many dirty
 pages
Message-Id: <20120712141343.e1cb7776.akpm@linux-foundation.org>
In-Reply-To: <20120712070501.GB21013@tiehlicka.suse.cz>
References: <1340117404-30348-1-git-send-email-mhocko@suse.cz>
	<20120619150014.1ebc108c.akpm@linux-foundation.org>
	<20120620101119.GC5541@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1207111818380.1299@eggly.anvils>
	<20120712070501.GB21013@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 09:05:01 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> When we are back to the patch. Is it going into 3.5? I hope so and I
> think it is really worth stable as well. Andrew?

What patch.   "memcg: prevent OOM with too many dirty pages"?

I wasn't planning on 3.5, given the way it's been churning around.  How
about we put it into 3.6 and tag it for a -stable backport, so it gets
a bit of a run in mainline before we inflict it upon -stable users?

