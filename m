Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1GLMmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:42:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1GLMmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:42:32 -0400
Subject: Re: [PATCH 0/4] mm, sparc64: Implement gup_fast()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20110712122608.938583937@chello.nl>
References: <20110712122608.938583937@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Jul 2011 14:42:11 +0200
Message-ID: <1310474531.14978.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 14:26 +0200, Peter Zijlstra wrote:
> With the recent mmu_gather changes that included generic RCU freeing of
> page-tables, it is now quite straight forward to implement gup_fast() on
> sparc64.
> 
> Andrew, please consider merging these patches.

Gah, quilt-mail ate all the From: headers again.. all 4 patches are in
fact written by davem. Do you want a resend?
