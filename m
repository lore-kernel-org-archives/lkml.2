Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2AXPxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:53:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2AXPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:53:09 -0500
Date: Tue, 24 Jan 2012 13:40:01 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        leonid.moiseichuk@nokia.com, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Message-ID: <20120124154001.GB10990@amt.cnet>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
 <1326788038-29141-2-git-send-email-minchan@kernel.org>
 <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
 <4F15A34F.40808@redhat.com>
 <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 08:51:13PM +0200, Pekka Enberg wrote:
> Hello,
> 
> Ok, so here's a proof of concept patch that implements sample-base
> per-process free threshold VM event watching using perf-like syscall
> ABI. I'd really like to see something like this that's much more
> extensible and clean than the /dev based ABIs that people have
> proposed so far.
> 
> 			Pekka

What is the practical advantage of a syscall, again?

