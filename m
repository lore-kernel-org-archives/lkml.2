Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2GPVIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:08:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2GPVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:08:48 -0400
Date: Mon, 16 Jul 2012 14:08:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH mmotm] memcg: further prevent OOM with too many dirty
 pages
Message-Id: <20120716140846.bc5cefb2.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1207160131120.3936@eggly.anvils>
References: <1340117404-30348-1-git-send-email-mhocko@suse.cz>
	<20120619150014.1ebc108c.akpm@linux-foundation.org>
	<20120620101119.GC5541@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1207111818380.1299@eggly.anvils>
	<20120712070501.GB21013@tiehlicka.suse.cz>
	<20120712141343.e1cb7776.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1207121539150.27721@eggly.anvils>
	<20120713082150.GA1448@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1207160111280.3936@eggly.anvils>
	<alpine.LSU.2.00.1207160131120.3936@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012 01:35:34 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> Incremental on top of what I believe you presently have in mmotm:
> better folded in on top of Michal's original and the may_enter_fs "fix".

I think I'll keep it as a separate patch, actually.  This is a pretty
tricky and error-prone area and all those details in the changelog may
prove useful next time this code explodes.
