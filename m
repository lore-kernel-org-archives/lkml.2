Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1FLWCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 18:02:32 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61021 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1FLWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 18:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to;
        b=DWdsyINLcVjFBwlBlMKu0/+jI+YZpZ+HhV2g50+DaEJkDv6ESwMCM5EET8q1pQSsWq
         3T2VlVzAsiYsgODoyGsq9y2GjWnTV2kWROHjEUJpL3TgNJ9Ao1Je1whe8GO8BXZaDwnO
         xBpOcxSJSEwBkOxN4qXFbQPOPbe0a8jqDKlrw=
Date: Sun, 12 Jun 2011 16:01:16 -0600
From: Jean Sacren <sakiwit@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/sched.c: Fix array initialization typo
Message-ID: <20110612220116.GB12311@mail.gmail.com>
References: <20110612213107.GA12816@mail.gmail.com>
 <20110612213549.GA21620@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612213549.GA21620@p183.telecom.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 13 Jun 2011 00:35:49 +0300
>
> On Sun, Jun 12, 2011 at 03:31:07PM -0600, Jean Sacren wrote:
> > The fix makes certain so that the size of the initialized arrays doesn't
> > go beyond the boundary set by the array size of 40.
> 
> Why would it possibly do that?

With that ',' comma, doesn't it imply there might be the 41st element in
the array? Despite the fact that that element is bogus.

Further, if the comma is there, what's the benefit? I know you're cool,
but is it cool in code that way as well?
> 
> And it's not a typo.

What is it then?
> 
> > @@ -1383,7 +1383,7 @@ static const int prio_to_weight[40] = {
> >   /*   0 */      1024,       820,       655,       526,       423,
> >   /*   5 */       335,       272,       215,       172,       137,
> >   /*  10 */       110,        87,        70,        56,        45,
> > - /*  15 */        36,        29,        23,        18,        15,
> > + /*  15 */        36,        29,        23,        18,        15
> >  };
> >  
> >  /*
> > @@ -1401,7 +1401,7 @@ static const u32 prio_to_wmult[40] = {
> >   /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
> >   /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
> >   /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
> > - /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
> > + /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153
> >  };

-- 
Jean Sacren
