Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2JAPW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:22:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50038 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2JAPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209261821380.7745@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com>
 <alpine.LSU.2.00.1209192021270.28543@eggly.anvils> <alpine.DEB.2.00.1209261821380.7745@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Oct 2012 08:22:35 -0700
X-Google-Sender-Auth: 4HHNlDpk61g4YuvDydodPd4Oo-0
Message-ID: <CA+55aFymzvPgw5O=MmHsedOmheNMYXXmy3munR6XDt5tQYEESA@mail.gmail.com>
Subject: Re: [patch for-3.6] mm, thp: fix mapped pages avoiding unevictable
 list on mlock
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 6:40 PM, David Rientjes <rientjes@google.com> wrote:
>
> Ok, sounds good.  If there's no objection, I'd like to ask Andrew to apply
> this to -mm and remove the cc to stable@vger.kernel.org since the
> mlock_vma_page() problem above is separate and doesn't conflict with this
> code, so I'll send a followup patch to address that.

So I deferred this (and the "mm, thp: fix mlock statistics" one) to
after 3.6, because Andrea indicated that they aren't critical. Now I'd
be ready to take them, but I suspect they are already in Andrew's
queue and I can forget about them.

Please holler if I need to take the two thp patches directly..

              Linus
