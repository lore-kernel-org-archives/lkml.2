Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1CIQ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:29:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45625 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1CIQ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:29:21 -0500
Date: Wed, 9 Mar 2011 16:28:50 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm: Rename drop_anon_vma to put_anon_vma
Message-ID: <20110309162850.GD19206@csn.ul.ie>
References: <20110217161948.045410404@chello.nl> <20110217162124.322205562@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110217162124.322205562@chello.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 05:19:49PM +0100, Peter Zijlstra wrote:
> The normal code pattern used in the kernel is: get/put.
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
