Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab0IJJEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:04:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51667 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab0IJJEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:04:44 -0400
Date: Fri, 10 Sep 2010 11:04:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] hugetlb, rmap: fixes and cleanups
Message-ID: <20100910110438.6aaf181e@basil.nowhere.org>
In-Reply-To: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 13:23:02 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Hi,
> 
> These are fix and cleanup patches for hugepage rmapping.
> All these were pointed out in the following thread (last 4 messages.)
> 
>   http://thread.gmane.org/gmane.linux.kernel.mm/52334

Looks all good to me. It's not strictly hwpoison related
though, so I assume they are better with Andrew than my tree.

I assume they do not depend on the earlier patchkit?
 
-Andi
