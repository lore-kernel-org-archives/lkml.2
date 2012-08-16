Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2HPPHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:07:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53260 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436Ab2HPPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:07:36 -0400
Date: Thu, 16 Aug 2012 16:06:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michel Lespinasse <walken@google.com>
Cc: "riel@redhat.com" <riel@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vrajesh@umich.edu" <vrajesh@umich.edu>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/5] kmemleak: use rbtree instead of prio tree
Message-ID: <20120816150628.GE30876@arm.com>
References: <1344324343-3817-1-git-send-email-walken@google.com>
 <1344324343-3817-4-git-send-email-walken@google.com>
 <CANN689EOZ64V_AO8B6N0-_B0_HdQZVk3dH8Ce5c=m5Q=ySDKUg@mail.gmail.com>
 <20120809083127.GC14102@arm.com>
 <CAHkRjk4pQOktEGFZy9Jd5NDth8f_+JUC0OrgcRUaCFGUEUOTKg@mail.gmail.com>
 <CANN689F_FgFP0tUwpTJmhWO+XaLH9+2tEb6xYJzonXVv5KsOSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689F_FgFP0tUwpTJmhWO+XaLH9+2tEb6xYJzonXVv5KsOSA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 09:53:07PM +0100, Michel Lespinasse wrote:
> On Wed, Aug 15, 2012 at 9:36 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > Couldn't test it because the patch got messed up somewhere on the
> > email path (tabs replaced with spaces). Is there a Git tree I can grab
> > it from (or you could just send it to me separately as attachment)?
> 
> Sorry about that. The original patch I sent to lkml & linux-mm wasn't
> corrupted, but the forward I sent you after I realized I had forgotten
> to include you was.
> 
> https://lkml.org/lkml/2012/8/7/52 has the original patch, and "get
> diff 1" in the left column can be used to retrieve it.

Thanks. It works fine in my tests and the scanning time seems to have
got down from 22s to 19s on my board.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
