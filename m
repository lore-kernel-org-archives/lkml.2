Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1ASQnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:43:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1ASQnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:43:23 -0500
MIME-Version: 1.0
Message-ID: <eaa7e0c3-ab9b-45e7-b396-7c59338e2ae2@default>
Date: Wed, 19 Jan 2011 08:42:26 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@Oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: RE: Ping? RE: [GIT PULL] mm/vfs/fs:cleancache for 2.6.37 merge window
References: <ec76a6ed-a1dc-4e8b-a4ac-1e72ab367d0f@default>
 <7b34b3ea-9436-4077-a35e-a5eaabd59813@default
 20101030120632.40345d0d.akpm@linux-foundation.org>
In-Reply-To: <20101030120632.40345d0d.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 27 Oct 2010 11:37:47 -0700 (PDT) Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> 
> > Ping?  I hope you are still considering this.  If not or if
> > there are any questions I can answer, please let me know.
> 
> What's happened here is that the patchset has gone through its
> iterations and a few people have commented and then after a while,
> nobody had anything to say about the code so nobody said anything more.
> 
> But silence doesn't mean acceptance - it just means that nobody had
> anything to say.
> 
> I think I looked at the earlier iterations, tried to understand the
> point behind it all, made a few code suggestions and eventually tuned
> out.  At that time (and hence at this time) I just cannot explain to
> myself why we would want to merge this code.
> 
> All new code is a cost/benefit decision.  The costs are pretty well
> known: larger codebase, more code for us and our "customers" to
> maintain and support, etc.  That the code pokes around in vfs and
> various filesystems does increase those costs a little.
> 
> But the extent of the benefits to our users aren't obvious to me.  The
> coe is still xen-specific, I believe?  If so, that immediately reduces
> the benefit side by a large amount simply because of the reduced
> audience.
> 
> We did spend some time trying to get this wired up to zram so that the
> feature would be potentially useful to *all* users, thereby setting the
> usefulness multiplier back to 1.0.  But I don't recall that anything
> came of this?
> 
> I also don't know how useful the code is to its intended
> micro-audience: xen users!
> 
> So can we please revisit all this from the top level?  Jeremy, your
> input would be valuable.  Christoph, I recall that you had technical
> objections - can you please repeat those?
> 
> It's the best I can do to kick this along, sorry.

Hi Andrew (and Linus) --

Time to re-open this conversation (for 2.6.39 merge window)?

Assuming GregKH approves kztmem as a staging driver, it should
now set "the usefulness multiplier back to 1.0". Kztmem
is a superset of Nitin's zcache and zram but more dynamic
and is completely independent of Xen and virtualization.

See kztmem overview: https://lkml.org/lkml/2011/1/18/170 

And I believe Christoph's technical objections have all been
resolved.  See longer version of previous reply here:
https://lkml.org/lkml/2010/10/30/226 

So please reconsider cleancache!

Thanks,
Dan

P.S. Christoph, apologies, I see I didn't have you on the dist list
for the kztmem patch.
