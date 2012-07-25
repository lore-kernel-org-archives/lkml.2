Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2GYT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:26:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2GYT0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:26:15 -0400
Date: Wed, 25 Jul 2012 12:26:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120725122613.b971360b.akpm@linux-foundation.org>
In-Reply-To: <20120725190351.GA4143@gmail.com>
References: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
	<20120725071044.GA27535@gmail.com>
	<20120725073503.GB1112@cmpxchg.org>
	<20120725115713.e56239b5.akpm@linux-foundation.org>
	<20120725190351.GA4143@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012 21:03:51 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> > This means that if the above code reappears in linux-next or 
> > mainline, the current copy of 
> > mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch 
> > will no longer update it, and I probably won't notice that 
> > omission.
> 
> Did you plan to send Johannes's memcg bits to Linus in this 
> merge window?

Yes.  I was kinda thinking of starting the bombing run on Monday but I
guess I could do the MM queue on Thursday.

