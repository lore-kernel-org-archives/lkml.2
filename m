Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2HaTrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:47:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2HaTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:47:03 -0400
Date: Fri, 31 Aug 2012 12:47:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 0/7] thp: transparent hugepages on s390
Message-Id: <20120831124702.8980b637.akpm@linux-foundation.org>
In-Reply-To: <20120831090757.2e29c834@de.ibm.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
	<20120830125444.86925ef3.akpm@linux-foundation.org>
	<20120831090757.2e29c834@de.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012 09:07:57 +0200
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > I grabbed them all.  Patches 1-3 look sane to me and I cheerfully
> > didn't read the s390 changes at all.  Hopefully Andrea will be able to
> > review at least patches 1-3 for us.
> > 
> > If that all goes well, how do we play this?  I'd prefer to merge 1-3
> > myself, as they do interact with ongoing MM development.  I can also
> > merge 4-7 if appropriate s390 maintainer acks are seen.  Or I can drop
> > them and the s390 parts can be merged via the s390 tree at a later
> > date?
> 
> I would really appreciate if Andrea could have a look at the code.

Yes please ;)

> I've
> read the patches and I am fine with them but it is very easy to miss some
> important bit.
> 
> As far as upstreaming is concerned: I can deal with the pure s390 parts
> via the s390 tree if that helps you. If you prefer the carry all of them,
> that is fine with me as well.

It would be easiest/simplest if I were to merge it all.  But that means
that the s390 developers wouldn't have tested it much, unless they're
testing linux-next?

I guess that's not the end of the world - you'll have a couple of
months after -rc1 to find and fix any problems.

