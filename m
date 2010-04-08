Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0DHUfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:35:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37816 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab0DHUfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:35:14 -0400
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: aarcange@redhat.com, avi@redhat.com, tglx@linutronix.de, riel@redhat.com,
       mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       npiggin@suse.de
In-Reply-To: <20100408.132935.202349434.davem@davemloft.net>
References: <20100408191737.296180458@chello.nl>
	 <20100408.132935.202349434.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 22:35:07 +0200
Message-ID: <1270758907.20295.3077.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 13:29 -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu, 08 Apr 2010 21:17:37 +0200
> 
> > This patch-set seems to build and boot on my x86_64 machines and even builds a
> > kernel. I've also attempted powerpc and sparc, which I've compile tested with
> > their respective defconfigs, remaining are (afaikt the rest uses the generic
> > tlb bits):
> 
> Did a build and test boot of this on my 128-cpu Niagara2 box, seems to
> work basically fine.

Wheee, thanks Dave!

