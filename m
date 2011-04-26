Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1DZNAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab1DZNAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:00:21 -0400
Date: Tue, 26 Apr 2011 15:00:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        raz ben yehuda <raziebe@gmail.com>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
Message-ID: <20110426130004.GA27267@random.random>
References: <20110415101248.GB22688@suse.de>
 <BANLkTik7H+cmA8iToV4j1ncbQqeraCaeTg@mail.gmail.com>
 <20110421110841.GA612@suse.de>
 <20110421142636.GA1835@barrios-desktop>
 <20110421160057.GA28712@suse.de>
 <20110421161402.GS5611@random.random>
 <BANLkTi=+fGe-hrV3c8r2jKzWG2BHU0GsFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=+fGe-hrV3c8r2jKzWG2BHU0GsFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 09:54:24AM +0900, Minchan Kim wrote:
> Before doing that, let's clear the point. You mentioned  it shouldn't
> be a common occurrence but you are suggesting we should do for code
> consistency POV. Am I right?

Yes, for code consistency and cleanup.

Thanks,
Andrea
