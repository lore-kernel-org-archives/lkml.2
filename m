Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0FUOb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:31:26 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:49433 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0FUObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:31:25 -0400
Date: Mon, 21 Jun 2010 09:31:10 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Manfred Spraul <manfred@colorfullife.com>
cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
In-Reply-To: <4C1CD791.101@colorfullife.com>
Message-ID: <alpine.DEB.2.00.1006210927310.4513@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <alpine.DEB.2.00.1006180955141.11575@router.home> <4C1CD791.101@colorfullife.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010, Manfred Spraul wrote:

> Hello Christoph,
>
> On 06/18/2010 04:56 PM, Christoph Lameter wrote:
> > One important fact that I forgot to mention: This is on a dual quad core
> > dell box (8 hardware threads) with CONCURRENCY_LEVEL set to 9.
> >
>
> - Which version of make do you use? That would be one suspect that might use
> semop().

$ make --version
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

This program built for x86_64-pc-linux-gnu

> - If I run make -j5 bzImage, then no semaphore arrays are used.
> Could you try to figure out which executable is doing the 'semop()' call?

Looks like this was ld

> Or: what's the output of ps xawwwww_

Need to do another run with a broken kernel for this.
