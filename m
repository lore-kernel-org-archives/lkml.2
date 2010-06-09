Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0FIWVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:21:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab0FIWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:21:33 -0400
Date: Wed, 9 Jun 2010 15:20:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Salman <sqazi@google.com>, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <1276119207.1745.154.camel@laptop>
Message-ID: <alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>  <alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org> <1276119207.1745.154.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Peter Zijlstra wrote:
> 
> Isn't: return a - base < b - base, the natural way to express this?

Quite possibly. I'd worry about the overflow case a bit, but it's 
certainly going to get the right value when base << MAX_INT.

		Linus
