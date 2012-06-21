Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab2FUTW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:22:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44574 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2FUTW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:22:57 -0400
Date: Thu, 21 Jun 2012 21:22:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        aarcange@redhat.com, peterz@infradead.org, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 4/7] mm: make page colouring code generic
Message-ID: <20120621192253.GD15472@liondog.tnic>
Reply-To: Borislav Petkov <borislav.petkov@amd.com>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	aarcange@redhat.com, peterz@infradead.org, minchan@gmail.com,
	kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
	mel@csn.ul.ie, linux-kernel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
 <1340057126-31143-5-git-send-email-riel@redhat.com>
 <20120619162747.fa31c86a.akpm@linux-foundation.org>
 <4FE35F4E.3080002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FE35F4E.3080002@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 01:52:14PM -0400, Rik van Riel wrote:
> >Some performance tests on the result would be interesting.  iirc, we've
> >often had trouble demonstrating much or any benefit from coloring.
> 
> On AMD Bulldozer, I do not know what the benefits are.

I have arranged for running a bunch of benchmarks with and without your
patchset on Bulldozer, basically everything you can get in autotest.

Also, if you have any other microbenchmarks or tests your want run, ping
me.

Thanks.

-- 
Regards/Gruss,
    Boris.
