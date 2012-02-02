Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab2BBT4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:56:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab2BBT4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:56:33 -0500
Date: Thu, 2 Feb 2012 11:56:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
Message-Id: <20120202115628.46150903.akpm@linux-foundation.org>
In-Reply-To: <CABqxG0fyH89YP+jpZ5nJoVfzOQ++J4EfGP42FtjxAv7OY9o+5w@mail.gmail.com>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
	<20120201131746.07e2219e.akpm@linux-foundation.org>
	<CABqxG0fyH89YP+jpZ5nJoVfzOQ++J4EfGP42FtjxAv7OY9o+5w@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012 10:13:43 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> On Thu, Feb 2, 2012 at 5:17 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 1 Feb 2012 14:34:20 +0800
> > Dave Young <dyoung@redhat.com> wrote:
> >
> >> tools/ is the better place for vm tools which are used by many people.
> >> Moving them to tools also make them open to more users instead of hide in
> >> Documentation folder.
> >>
> >
> > It would be nice to covert these into simple pass/fail tests and
> > promote them to tools/testing/selftests/.
> 
> Andrew, I'm not clear about this, do you means to selftest
> hugepage-mmap.c,  hugepage-shm.c  and map_hugetlb.c?

Those ones can go into selftests.

> I think slabinfo and page-types should stay in tools/vm/.

Yes, those are tools, not selftests.
