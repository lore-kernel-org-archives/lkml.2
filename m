Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab0DMEPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:15:22 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:52563 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0DMEPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PCC91HVWdbgUMyYiEc8m1teFhTJFvK0XNB1VSxcbw9y4i483fd8pdKtJB2/GC1hda/
         9kX2/aaFv2chKTCswzm70/bVsF3Nz6E8IuTzhgkZ0FkqmSDQJRcSRIaZkZftQT7TvLiT
         GWpfszgpZpcYNw3hGItEtqodBd5eo7u3d373I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic>
	 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
	 <20100412072056.GA2432@liondog.tnic>
	 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
	 <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic>
	 <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
Date: Tue, 13 Apr 2010 13:15:20 +0900
Message-ID: <y2h28c262361004122115k3c6e19b6w593389e98d31b0c@mail.gmail.com>
Subject: Re: [PATCH 2/4] vma_adjust: fix the copying of anon_vma chains
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 5:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 10 Apr 2010 15:22:30 -0700
> Subject: [PATCH 2/4] vma_adjust: fix the copying of anon_vma chains
>
> When we move the boundaries between two vma's due to things like
> mprotect, we need to make sure that the anon_vma of the pages that got
> moved from one vma to another gets properly copied around.  And that was
> not always the case, in this rather hard-to-follow code sequence.
>
> Clarify the code, and fix it so that it copies the anon_vma from the
> right source.
>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
