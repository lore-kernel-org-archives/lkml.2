Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2CEUHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:07:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab2CEUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:07:50 -0500
Date: Mon, 5 Mar 2012 12:07:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-team@fedoraproject.org
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
Message-Id: <20120305120749.b843fbde.akpm@linux-foundation.org>
In-Reply-To: <20120305195952.GC17489@zod.bos.redhat.com>
References: <20120215183317.GA26977@redhat.com>
	<alpine.LSU.2.00.1202151801020.19691@eggly.anvils>
	<20120216070753.GA23585@redhat.com>
	<alpine.LSU.2.00.1202160130500.16147@eggly.anvils>
	<20120216214245.GD23585@redhat.com>
	<alpine.LSU.2.00.1203021444040.3448@eggly.anvils>
	<20120302145811.93bb49e9.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1203021503420.3541@eggly.anvils>
	<20120305195952.GC17489@zod.bos.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012 14:59:53 -0500
Josh Boyer <jwboyer@redhat.com> wrote:

> On Fri, Mar 02, 2012 at 03:09:29PM -0800, Hugh Dickins wrote:
> > On Fri, 2 Mar 2012, Andrew Morton wrote:
> > > On Fri, 2 Mar 2012 14:53:32 -0800 (PST)
> > > Hugh Dickins <hughd@google.com> wrote:
> > > 
> > > > Subject: Re: exit_mmap() BUG_ON triggering since 3.1
> > > > ...
> > > > Subject: [PATCH] mm: thp: fix BUG on mm->nr_ptes
> > > 
> > > So it's needed in 3.1.x and 3.2.x?
> > 
> > Indeed it would be needed in -stable, thanks, I forgot to add that.
> > 
> > And although Fedora only got reports from 3.1 onwards, I believe it
> > would equally be needed in 3.0.x.  3.1.x is closed down now, but
> > 3.0.x and 3.2.x are still open.
> > 
> > I've not yet tried applying it to the latest of either of those: maybe
> > it applies cleanly and correctly, but I could imagine movements too.
> > But the first step, yes, is to Cc: stable@vger.kernel.org
> 
> I don't see this in linux-next, 3.3-rcX, the stable-queue, or really
> anywhere at all at the moment.  Did the patch get swallowed up by some
> kind of evil code Eagle of Doom before making it into the safety of a
> tree somewhere?

I have it queued for 3.3.  It's taking a while to get things into -next
at present because they're breaking things faster than I can fix them :(

