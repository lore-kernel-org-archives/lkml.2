Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2DXRTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:19:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2DXRTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:19:44 -0400
Message-ID: <1335287973.28150.213.camel@twins>
Subject: Re: [RFC][PATCH 3/3] math128, x86_64: Implement {mult,add}_u128 in
 64bit asm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 24 Apr 2012 19:19:33 +0200
In-Reply-To: <4F96E01E.6040109@zytor.com>
References: <20120424161039.293018424@chello.nl>
	  <20120424162224.588822231@chello.nl> <4F96D604.5050709@zytor.com>
	 <1335285395.28150.204.camel@twins> <4F96E01E.6040109@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 10:17 -0700, H. Peter Anvin wrote:
> On 04/24/2012 09:36 AM, Peter Zijlstra wrote:
> > On Tue, 2012-04-24 at 09:34 -0700, H. Peter Anvin wrote:
> >> On 04/24/2012 09:10 AM, Peter Zijlstra wrote:
> >>
> >> Are you sure that gcc won't simply generate this code already if given
> >> "unsigned __int128"?
> > 
> > It might, but I've been told some GCC versions had issues, also lots of
> > archs fall back to libgcc functions.
> > 
> 
> Yes, but this is specific to x86-64.  If gcc can generate the code it
> can also schedule the code, which it can't for assembly...

Ok, but are you sure unsigned __int128 works for all gcc versions we
support?
