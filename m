Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1GMWdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:33:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab1GMWdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:33:55 -0400
Date: Wed, 13 Jul 2011 15:33:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] mm, sparc64: Implement gup_fast()
Message-Id: <20110713153348.b68b4196.akpm@linux-foundation.org>
In-Reply-To: <1310474531.14978.29.camel@twins>
References: <20110712122608.938583937@chello.nl>
	<1310474531.14978.29.camel@twins>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 14:42:11 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-07-12 at 14:26 +0200, Peter Zijlstra wrote:
> > With the recent mmu_gather changes that included generic RCU freeing of
> > page-tables, it is now quite straight forward to implement gup_fast() on
> > sparc64.
> > 
> > Andrew, please consider merging these patches.
> 
> Gah, quilt-mail ate all the From: headers again.. all 4 patches are in
> fact written by davem. Do you want a resend?

I have an editor ;)

I expect these would get more (ie: non-zero) testing if they were
merged via Dave's tree?

