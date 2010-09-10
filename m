Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0IJLsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:48:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58051 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0IJLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q1e6VMdjxX4UmvJbK7feG6oThmJLsPMnspF1C3vAEiQ+uXaRXBjNkfItZuPQX3HzW3
         hXzTYHWbDhADy8Ogiig6BqHGWlxanA1YitrKVfsvg9IoknoO30M/NeEERUlCLLKjIc0q
         nBUZJJGwfG7hOQ/AG3o2W6tDOahxWMWeHLOl4=
Date: Fri, 10 Sep 2010 20:47:59 +0900
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] hugetlb, rmap: fixes and cleanups
Message-ID: <20100910114759.GA5687@hammershoi.dip.jp>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com> <20100910110438.6aaf181e@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100910110438.6aaf181e@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 11:04:38AM +0200, Andi Kleen wrote:
> On Fri, 10 Sep 2010 13:23:02 +0900
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Hi,
> > 
> > These are fix and cleanup patches for hugepage rmapping.
> > All these were pointed out in the following thread (last 4 messages.)
> > 
> >   http://thread.gmane.org/gmane.linux.kernel.mm/52334
> 
> Looks all good to me. It's not strictly hwpoison related
> though, so I assume they are better with Andrew than my tree.

Agreed.

> I assume they do not depend on the earlier patchkit?

No, all changes on this patchset update code merged with
"HWPOISON for hugepage" patchset.

Thanks,
Naoya Horiguchi
