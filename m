Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1BJEXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:23:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45818 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1BJEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:23:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Feb 2011 13:16:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix out-of-date comments which refers non-existent
 functions
Message-Id: <20110210131644.4c3dc48d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikdBhSWAoP6TDRExSV2rHmWDkEc0foSKvqJt=tx@mail.gmail.com>
References: <1297262537-7425-1-git-send-email-ozaki.ryota@gmail.com>
	<20110210085823.2f99b81c.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikdBhSWAoP6TDRExSV2rHmWDkEc0foSKvqJt=tx@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 12:58:21 +0900
Ryota Ozaki <ozaki.ryota@gmail.com> wrote:

> On Thu, Feb 10, 2011 at 8:58 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed,  9 Feb 2011 23:42:17 +0900
> > Ryota Ozaki <ozaki.ryota@gmail.com> wrote:
> >
> >> From: Ryota Ozaki <ozaki.ryota@gmail.com>
> >>
> >> do_file_page and do_no_page don't exist anymore, but some comments
> >> still refers them. The patch fixes them by replacing them with
> >> existing ones.
> >>
> >> Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
> >
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Thanks, Kamezawa-san.
> 
> >
> > It seems there are other ones ;)
> > ==
> >    Searched full:do_no_page (Results 1 - 3 of 3) sorted by relevancy
> >
> >  /linux-2.6-git/arch/alpha/include/asm/
> > H A D   cacheflush.h    66 /* This is used only in do_no_page and do_swap_page. */
> >  /linux-2.6-git/arch/avr32/mm/
> > H A D   cache.c         116 * This one is called from do_no_page(), do_swap_page() and install_page().
> >  /linux-2.6-git/mm/
> > H A D   memory.c        2121 * and do_anonymous_page and do_no_page can safely check later on).
> > 2319 * do_no_page is protected similarly.
> 
> Nice catch :-) Cloud I assemble all fixes into one patch?
> 
>   ozaki-r
> 

Yes, I think it's allowed. 

Thanks,
-Kame


