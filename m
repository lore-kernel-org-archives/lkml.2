Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0DZL7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 07:59:35 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41011 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0DZL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 07:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MWhbWYapjD7zOBCYYkoy1JjQnZv8ZxFhgn3vjvJ/71jud8WuViOhsUd/Pfk7UhoHzL
         S1YhAuVwk+yiLqg5WVa4ct0HB/F+FkCzdhBRM77Pk5xYHFNRzUSIAIBBq3MiTwusEiOE
         PF1fcUAe95lXYfRPnqopa9Q5MDmQLZKDFitl4=
MIME-Version: 1.0
In-Reply-To: <4BD57213.7060207@linux.vnet.ibm.com>
References: <20100322235053.GD9590@csn.ul.ie>
	 <20100419214412.GB5336@cmpxchg.org>
	 <4BCD55DA.2020000@linux.vnet.ibm.com>
	 <20100420153202.GC5336@cmpxchg.org> <4BCDE2F0.3010009@redhat.com>
	 <4BCE7DD1.70900@linux.vnet.ibm.com>
	 <4BCEAAC6.7070602@linux.vnet.ibm.com> <4BCEFB4C.1070206@redhat.com>
	 <4BCFEAD0.4010708@linux.vnet.ibm.com>
	 <4BD57213.7060207@linux.vnet.ibm.com>
Date: Mon, 26 Apr 2010 20:59:30 +0900
Message-ID: <p2y2f11576a1004260459jcaf79962p50e4d29f990019ee@mail.gmail.com>
Subject: Re: Subject: [PATCH][RFC] mm: make working set portion that is 
	protected tunable v2
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, gregkh@novell.com,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Corrado Zoccolo <czoccolo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've quick reviewed your patch. but unfortunately I can't write my
reviewed-by sign.

> Subject: [PATCH][RFC] mm: make working set portion that is protected tunable v2
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>
> *updates in v2*
> - use do_div
>
> This patch creates a knob to help users that have workloads suffering from the
> fix 1:1 active inactive ratio brought into the kernel by "56e49d21 vmscan:
> evict use-once pages first".
> It also provides the tuning mechanisms for other users that want an even bigger
> working set to be protected.

We certainly need no knob. because typical desktop users use various
application,
various workload. then, the knob doesn't help them.

Probably, I've missed previous discussion. I'm going to find your previous mail.
