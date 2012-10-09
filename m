Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2JIOWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab2JIOWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:22:15 -0400
Message-ID: <1349792507.2759.283.camel@ul30vt.home>
Subject: Re: [PATCH v3 10/10] mm: kill vma flag VM_RESERVED and
 mm->reserved_vm counter
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>
Date: Tue, 09 Oct 2012 08:21:47 -0600
In-Reply-To: <CA+55aFzCCSE3bnPL7pquYq9pW6YLs_2QZR7r9kZEgwxxc7rzYg@mail.gmail.com>
References: <20120731103724.20515.60334.stgit@zurg>
	 <20120731104239.20515.702.stgit@zurg>
	 <1349776921.21172.4091.camel@edumazet-glaptop>
	 <CA+55aFzCCSE3bnPL7pquYq9pW6YLs_2QZR7r9kZEgwxxc7rzYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 21:12 +0900, Linus Torvalds wrote:
> On Tue, Oct 9, 2012 at 7:02 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > It seems drivers/vfio/pci/vfio_pci.c uses VM_RESERVED
> 
> Yeah, I just pushed out what I think is the right (trivial) fix.

Thank you, looks correct to me as well.

Alex

