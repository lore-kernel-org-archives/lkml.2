Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab0EYPR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:17:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757090Ab0EYPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:17:56 -0400
Date: Tue, 25 May 2010 08:13:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
In-Reply-To: <AANLkTimazVL8G-XQURiQ1s0M3NKa2ndXNceSaw9sADRQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005250812100.3689@i5.linux-foundation.org>
References: <20100524070309.GU2516@laptop> <alpine.DEB.2.00.1005240852580.5045@router.home> <20100525020629.GA5087@laptop> <AANLkTik2O-_Fbh-dq0sSLFJyLU7PZi4DHm85lCo4sugS@mail.gmail.com> <20100525070734.GC5087@laptop> <AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
 <20100525081634.GE5087@laptop> <AANLkTilJBY0sinB365lIZFUaMgMCZ1xyhMdXRTJTVDSV@mail.gmail.com> <20100525093410.GH5087@laptop> <AANLkTikXp5LlKLK1deKOQpciUFNugjlQah5QpNcImf39@mail.gmail.com> <20100525101924.GJ5087@laptop>
 <AANLkTimazVL8G-XQURiQ1s0M3NKa2ndXNceSaw9sADRQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 May 2010, Pekka Enberg wrote:
> 
> I would have liked to see SLQB merged as well but it just didn't happen.

And it's not going to. I'm not going to merge YASA that will stay around 
for years, not improve on anything, and will just mean that there are some 
bugs that developers don't see because they depend on some subtle 
interaction with the sl*b allocator.

We've got three. That's at least one too many. We're not adding any new 
ones until we've gotten rid of at least one old one.

		Linus
