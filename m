Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab1BQRg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:36:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:35443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1BQRg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:36:57 -0500
Subject: Re: [PATCH 0/3] mm: Simplify anon_vma lifetime rules
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <20110217161948.045410404@chello.nl>
References: <20110217161948.045410404@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 18:36:16 +0100
Message-ID: <1297964176.2413.2027.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 17:19 +0100, Peter Zijlstra wrote:
> As per Linus' request, isolate these three patches.

---
 include/linux/rmap.h |   45 ++++++---------------------
 mm/ksm.c             |   23 +++-----------
 mm/migrate.c         |    4 +-
 mm/rmap.c            |   83 +++++++++++++++++----------------------------------
 4 files changed, 46 insertions(+), 109 deletions(-)

