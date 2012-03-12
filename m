Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2CLXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:09:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43365 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2CLXJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:09:56 -0400
Date: Mon, 12 Mar 2012 16:09:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312230949.GN23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120312223113.GB18359@tango.0pointer.de>
 <20120312230020.GL23255@google.com>
 <1331593367.18960.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331593367.18960.66.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Tue, Mar 13, 2012 at 12:02:47AM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 16:00 -0700, Tejun Heo wrote:
> > 
> > Ooh, both will be available to choose from.  I was trying to explain
> > that there can be configuration only at one layer for any task so that
> > it can be mapped to flat hierarchy.  Where to apply the config will be
> > selected by the user (or system tool). 
> 
> Thus in effect this is a false choice, since Lennart and assorted idiots
> conspire against sanity by pushing systemd into our every orifice, and
> since he just said systemd requires one of the two, the choice will be
> made for us, lest we forfeit wanting to boot our system.

I think it should be fine as long as systemd or whatever system cgroup
manager can be told to stay aside about limits.  Everyone doing their
own thing and ending up competing directly under /sys/fs/cgroup/
worries me more.  cgroup config fs doesn't have enough flexibility or
proper provisions for sharing while encouraging direct usage.  That's
not a good combination.

Thanks.

-- 
tejun
