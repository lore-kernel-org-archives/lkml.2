Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475Ab2FAQ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:29:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51470 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965417Ab2FAQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120601161640.GA329@x4>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
 <20120601161640.GA329@x4>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 09:28:56 -0700
X-Google-Sender-Auth: WjkHH_IY3griDFqCf6FEe7Cv7ms
Message-ID: <CA+55aFyrX30_=V=fiOAt8rXOuj=YdbgrzehknSz9-6qNGKFp-Q@mail.gmail.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 9:16 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> I've also hit this warning today:

Can you try the patch by Hugh Dickins earlier in this thread?

Dave is reporting tentative success with it, even though I don't think
we really understand this thing fully yet. Getting way more testing
would still be good, though.

                  Linus
