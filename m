Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab2CBXKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:10:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49322 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2CBXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:10:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.135.71 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 2 Mar 2012 15:09:29 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fedoraproject.org
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
In-Reply-To: <20120302145811.93bb49e9.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1203021503420.3541@eggly.anvils>
References: <20120215183317.GA26977@redhat.com> <alpine.LSU.2.00.1202151801020.19691@eggly.anvils> <20120216070753.GA23585@redhat.com> <alpine.LSU.2.00.1202160130500.16147@eggly.anvils> <20120216214245.GD23585@redhat.com> <alpine.LSU.2.00.1203021444040.3448@eggly.anvils>
 <20120302145811.93bb49e9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Andrew Morton wrote:
> On Fri, 2 Mar 2012 14:53:32 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > Subject: Re: exit_mmap() BUG_ON triggering since 3.1
> > ...
> > Subject: [PATCH] mm: thp: fix BUG on mm->nr_ptes
> 
> So it's needed in 3.1.x and 3.2.x?

Indeed it would be needed in -stable, thanks, I forgot to add that.

And although Fedora only got reports from 3.1 onwards, I believe it
would equally be needed in 3.0.x.  3.1.x is closed down now, but
3.0.x and 3.2.x are still open.

I've not yet tried applying it to the latest of either of those: maybe
it applies cleanly and correctly, but I could imagine movements too.
But the first step, yes, is to Cc: stable@vger.kernel.org

Thanks,
Hugh
