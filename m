Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab0DHU3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:29:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45051
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933412Ab0DHU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:29:34 -0400
Date: Thu, 08 Apr 2010 13:29:35 -0700 (PDT)
Message-Id: <20100408.132935.202349434.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: aarcange@redhat.com, avi@redhat.com, tglx@linutronix.de, riel@redhat.com,
       mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       npiggin@suse.de
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100408191737.296180458@chello.nl>
References: <20100408191737.296180458@chello.nl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 08 Apr 2010 21:17:37 +0200

> This patch-set seems to build and boot on my x86_64 machines and even builds a
> kernel. I've also attempted powerpc and sparc, which I've compile tested with
> their respective defconfigs, remaining are (afaikt the rest uses the generic
> tlb bits):

Did a build and test boot of this on my 128-cpu Niagara2 box, seems to
work basically fine.
