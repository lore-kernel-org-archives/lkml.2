Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab0DMEQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:16:22 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:57931 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0DMEQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:16:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rpt9d09InucPXkXLyyuQc4Aj5zl080SHBJm6AOU9CA0atI3EvZkAC3QHq100EPRxBm
         fB/F1Cr53k/b5fVJ3PZ23J2VXs74ZCMTGdhJmumG2qxcCVcmwT+6iE2f/BgzVHmLuoVt
         Kwi968OfAaeV0lEy+QLrGa2ru3/0E+foLrPe0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic>
	 <20100412072056.GA2432@liondog.tnic>
	 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
	 <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic>
	 <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
Date: Tue, 13 Apr 2010 13:16:20 +0900
Message-ID: <g2k28c262361004122116s1fb55791t9dee6bcf56fe8c14@mail.gmail.com>
Subject: Re: [PATCH 3/4] anon_vma: clone the anon_vma chain in the right order
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
> Date: Sun, 11 Apr 2010 17:15:03 -0700
> Subject: [PATCH 3/4] anon_vma: clone the anon_vma chain in the right order
>
> We want to walk the chain in reverse order when cloning it, so that the
> order of the result chain will be the same as the order in the source
> chain.  When we add entries to the chain, they go at the head of the
> chain, so we want to add the source head last.
>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
