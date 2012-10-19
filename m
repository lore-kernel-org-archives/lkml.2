Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab2JSOnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:43:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:50169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab2JSOnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:43:45 -0400
Message-ID: <1350657808.2768.29.camel@twins>
Subject: Re: [tip:numa/core] sched/numa/mm: Improve migration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mgorman@suse.de, tglx@linutronix.de
Date: Fri, 19 Oct 2012 16:43:28 +0200
In-Reply-To: <20121019135122.GI31863@cmpxchg.org>
References: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
	 <20121019135122.GI31863@cmpxchg.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 09:51 -0400, Johannes Weiner wrote:
> It's slightly ugly that migrate_page_copy() actually modifies the
> existing page (deactivation, munlock) when you end up having to revert
> back to it. 

The worst is actually calling copy_huge_page() on a THP.. it seems to
work though ;-)


