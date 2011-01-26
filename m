Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1AZLAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:00:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:60597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1AZLAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:00:43 -0500
Subject: Re: [PATCH 09/25] ia64: Preemptible mmu_gather
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: tony.luck@intel.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <4d3f3f522012086c15@agluck-desktop.sc.intel.com>
References: <4d3f3f522012086c15@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 12:01:05 +0100
Message-ID: <1296039665.28776.1152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 13:23 -0800, tony.luck@intel.com wrote:
> Okay ... then could you swap out your part 09/25 for this version that
> has a #define and a comment.  You can add
> 
> Acked-by: Tony Luck <tony.luck@intel.com>
> 
Thanks Tony!
