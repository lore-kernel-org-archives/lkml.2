Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0J3THn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:07:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab0J3THl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:07:41 -0400
Date: Sat, 30 Oct 2010 12:06:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Ping? RE: [GIT PULL] mm/vfs/fs:cleancache for 2.6.37 merge
 window
Message-Id: <20101030120632.40345d0d.akpm@linux-foundation.org>
In-Reply-To: <7b34b3ea-9436-4077-a35e-a5eaabd59813@default>
References: <ec76a6ed-a1dc-4e8b-a4ac-1e72ab367d0f@default>
	<7b34b3ea-9436-4077-a35e-a5eaabd59813@default>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 11:37:47 -0700 (PDT) Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> Ping?  I hope you are still considering this.  If not or if
> there are any questions I can answer, please let me know.

What's happened here is that the patchset has gone through its
iterations and a few people have commented and then after a while,
nobody had anything to say about the code so nobody said anything more.

But silence doesn't mean acceptance - it just means that nobody had
anything to say.

I think I looked at the earlier iterations, tried to understand the
point behind it all, made a few code suggestions and eventually tuned
out.  At that time (and hence at this time) I just cannot explain to
myself why we would want to merge this code.

All new code is a cost/benefit decision.  The costs are pretty well
known: larger codebase, more code for us and our "customers" to
maintain and support, etc.  That the code pokes around in vfs and
various filesystems does increase those costs a little.

But the extent of the benefits to our users aren't obvious to me.  The
code is still xen-specific, I believe?  If so, that immediately reduces
the benefit side by a large amount simply because of the reduced
audience.

We did spend some time trying to get this wired up to zram so that the
feature would be potentially useful to *all* users, thereby setting the
usefulness multiplier back to 1.0.  But I don't recall that anything
came of this?

I also don't know how useful the code is to its intended
micro-audience: xen users!


So can we please revisit all this from the top level?  Jeremy, your
input would be valuable.  Christoph, I recall that you had technical
objections - can you please repeat those?


It's the best I can do to kick this along, sorry.
