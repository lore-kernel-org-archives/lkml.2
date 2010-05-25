Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab0EYRCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:02:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EYRCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JIXHLy6fe7a46KKygY1eEZP50WQXExEd4HkKnVxYwvVVIMBI3RXJaIpj1OQuaf0ZXY
         f0GyjE8VV5hruG5/+dO+fmNiGlGQQY32a07T9xXho4yMMmpH7vLLnuUtewmwk1OivLtw
         r46jg7ra+s1LnKIYeEDvHR3HGVP9tNQMvQMHc=
MIME-Version: 1.0
In-Reply-To: <20100525154352.GB20853@laptop>
References: <AANLkTik2O-_Fbh-dq0sSLFJyLU7PZi4DHm85lCo4sugS@mail.gmail.com>
	<20100525070734.GC5087@laptop>
	<AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
	<20100525081634.GE5087@laptop>
	<AANLkTilJBY0sinB365lIZFUaMgMCZ1xyhMdXRTJTVDSV@mail.gmail.com>
	<20100525093410.GH5087@laptop>
	<AANLkTikXp5LlKLK1deKOQpciUFNugjlQah5QpNcImf39@mail.gmail.com>
	<20100525101924.GJ5087@laptop>
	<AANLkTimazVL8G-XQURiQ1s0M3NKa2ndXNceSaw9sADRQ@mail.gmail.com>
	<alpine.LFD.2.00.1005250812100.3689@i5.linux-foundation.org>
	<20100525154352.GB20853@laptop>
Date: Tue, 25 May 2010 20:02:32 +0300
X-Google-Sender-Auth: hh56kG4ZkmY0HxQb3yAoxHruZsI
Message-ID: <AANLkTilEIwPSN-stGGuu5wV4Q6Ty0GytNMpfq-vRpK_k@mail.gmail.com>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Tue, May 25, 2010 at 6:43 PM, Nick Piggin <npiggin@suse.de> wrote:
> As far as I can see, there was never a good reason to replace SLAB
> rather than clean up its code and make incremental improvements.

I'm not totally convinced but I guess we're about to find that out.
How do you propose we benchmark SLAB while we clean it up and change
things to make sure we don't make the same mistakes as we did with
SLUB (i.e. miss an important workload like TPC-C)?

                        Pekka
