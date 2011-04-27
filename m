Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1D0Gdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:33:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1D0Gdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:33:40 -0400
Date: Wed, 27 Apr 2011 08:33:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jack Steiner <steiner@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK
 is not set
Message-ID: <20110427063318.GC17079@elte.hu>
References: <20110425181136.055235992@gulag1.americas.sgi.com>
 <20110425181136.211858618@gulag1.americas.sgi.com>
 <20110425154835.7d41d89e.akpm@linux-foundation.org>
 <4DB6FBC2.7000806@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB6FBC2.7000806@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> 
> 
> Andrew Morton wrote:
> >On Mon, 25 Apr 2011 13:11:37 -0500
> >Mike Travis <travis@sgi.com> wrote:
> >
> >>	Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead
> >>	of having to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of
> >>	code calling that function.
> >>
> >>Authored-by: Yinghai Lu <yinghai@kernel.org>
> >>Signed-off-by: Mike Travis <travis@sgi.com>
> >
> >There is no such thing as "Authored-by:".  If this patch was written by
> >yinghai then it must be tagged as From:him at the top of the changelog
> >and preferably has his signed-off-by: at the end.
> >
> >Please clarify?
> 
> Yes, you have it correct.  I had added the From: line but when I receive
> the email, it's removed.
> 
> Why not have an "Authored-by"?  That would eliminate the sendmail program
> from screwing it up?

"From:" headers are properly recognized by Git and both git log and git 
annotate will show the right authorship. Authored-by does not get propagated.

Also, sendmail does not screw up From: headers that are in the body of the 
email - forwarding emails is one of the oldest things that can be done to 
emails.

Thanks,

	Ingo
