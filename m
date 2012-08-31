Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2HaHIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:08:15 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60492 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2HaHIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:08:13 -0400
Date: Fri, 31 Aug 2012 09:07:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 0/7] thp: transparent hugepages on s390
Message-ID: <20120831090757.2e29c834@de.ibm.com>
In-Reply-To: <20120830125444.86925ef3.akpm@linux-foundation.org>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
	<20120830125444.86925ef3.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12083107-3548-0000-0000-000002F9B41E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2012 12:54:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Aug 2012 17:32:57 +0200
> Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> 
> > This patch series adds support for transparent hugepages on System z.
> > Small changes to common code are necessary with regard to a different
> > pgtable_t, tlb flushing and kvm behaviour on s390, see patches 1 to 3.
> 
> "RFC" always worries me.  I read it as "Really Flakey Code" ;) Is it
> still appropriate to this patchset?

The code quality is IMHO already good. We do change common mm code though
and we want to get some feedback on that.

> I grabbed them all.  Patches 1-3 look sane to me and I cheerfully
> didn't read the s390 changes at all.  Hopefully Andrea will be able to
> review at least patches 1-3 for us.
> 
> If that all goes well, how do we play this?  I'd prefer to merge 1-3
> myself, as they do interact with ongoing MM development.  I can also
> merge 4-7 if appropriate s390 maintainer acks are seen.  Or I can drop
> them and the s390 parts can be merged via the s390 tree at a later
> date?

I would really appreciate if Andrea could have a look at the code. I've
read the patches and I am fine with them but it is very easy to miss some
important bit.

As far as upstreaming is concerned: I can deal with the pure s390 parts
via the s390 tree if that helps you. If you prefer the carry all of them,
that is fine with me as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

