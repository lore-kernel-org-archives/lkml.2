Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0EYKrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:47:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61453 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab0EYKrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AK7HsjvYRdKmcld1a0vKawEyCiM1fBHvWzzVNaQ9CTiLi0GUaYBpQQihpJ9jge+Q7K
         3uu9EkNbLAyaXPj0jxL4IO5KYY4QC9x+gtfzgrM9K4sM7S8o0GGk98XXvA1XFbkbzIAS
         BJ/A0qPxxaJeZoEEwKKRiZk+NYARcUyy3mZSI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1005250257100.8045@chino.kir.corp.google.com>
References: <20100521211452.659982351@quilx.com>
	<20100524070309.GU2516@laptop>
	<alpine.DEB.2.00.1005240852580.5045@router.home>
	<20100525020629.GA5087@laptop>
	<AANLkTik2O-_Fbh-dq0sSLFJyLU7PZi4DHm85lCo4sugS@mail.gmail.com>
	<20100525070734.GC5087@laptop>
	<AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
	<alpine.DEB.2.00.1005250257100.8045@chino.kir.corp.google.com>
Date: Tue, 25 May 2010 13:47:30 +0300
X-Google-Sender-Auth: 1SgMBGrcErnAxho1q3HYI19oHko
Message-ID: <AANLkTin5PNELUXc6oCHadVyX-YcAEalRSppjz4GMyIBh@mail.gmail.com>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, May 25, 2010 at 1:02 PM, David Rientjes <rientjes@google.com> wrote:
>> I wouldn't say it's a nightmare, but yes, it could be better. From my
>> point of view SLUB is the base of whatever the future will be because
>> the code is much cleaner and simpler than SLAB.
>
> The code may be much cleaner and simpler than slab, but nobody (to date)
> has addressed the significant netperf TCP_RR regression that slub has, for
> example.  I worked on a patchset to do that for a while but it wasn't
> popular because it added some increments to the fastpath for tracking
> data.

Yes and IIRC I asked you to resend the series because while I care a
lot about performance regressions, I simply don't have the time or the
hardware to reproduce and fix the weird cases you're seeing.

                        Pekka
