Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab2H3Tyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:54:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2H3Tyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:54:46 -0400
Date: Thu, 30 Aug 2012 12:54:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 0/7] thp: transparent hugepages on s390
Message-Id: <20120830125444.86925ef3.akpm@linux-foundation.org>
In-Reply-To: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2012 17:32:57 +0200
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> This patch series adds support for transparent hugepages on System z.
> Small changes to common code are necessary with regard to a different
> pgtable_t, tlb flushing and kvm behaviour on s390, see patches 1 to 3.

"RFC" always worries me.  I read it as "Really Flakey Code" ;) Is it
still appropriate to this patchset?

I grabbed them all.  Patches 1-3 look sane to me and I cheerfully
didn't read the s390 changes at all.  Hopefully Andrea will be able to
review at least patches 1-3 for us.

If that all goes well, how do we play this?  I'd prefer to merge 1-3
myself, as they do interact with ongoing MM development.  I can also
merge 4-7 if appropriate s390 maintainer acks are seen.  Or I can drop
them and the s390 parts can be merged via the s390 tree at a later
date?

