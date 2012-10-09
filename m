Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2JIMNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:13:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50351 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2JIMNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:13:09 -0400
MIME-Version: 1.0
In-Reply-To: <1349776921.21172.4091.camel@edumazet-glaptop>
References: <20120731103724.20515.60334.stgit@zurg> <20120731104239.20515.702.stgit@zurg>
 <1349776921.21172.4091.camel@edumazet-glaptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Oct 2012 21:12:48 +0900
X-Google-Sender-Auth: gNeaPz8uCmnBPg3HkpbzCAXIbs4
Message-ID: <CA+55aFzCCSE3bnPL7pquYq9pW6YLs_2QZR7r9kZEgwxxc7rzYg@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] mm: kill vma flag VM_RESERVED and
 mm->reserved_vm counter
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Alex Williamson <alex.williamson@redhat.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 7:02 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> It seems drivers/vfio/pci/vfio_pci.c uses VM_RESERVED

Yeah, I just pushed out what I think is the right (trivial) fix.

               Linus
