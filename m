Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1FUOoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:44:39 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59837 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1FUOoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:44:34 -0400
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP
 configurable
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <1308643849-3325-2-git-send-email-amwang@redhat.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com>
	 <1308643849-3325-2-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 07:44:21 -0700
Message-ID: <1308667461.11430.315.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 16:10 +0800, Amerigo Wang wrote:
> Don't hard-code 512M as the threshold in kernel, make it configruable,
> and set 512M by default.
> 
> And print info when THP is disabled automatically on small systems.
> 
> V2: Add more description in help messages, correct some typos,
> print the mini threshold too.

This seems sane to me.  The printk probably could probably stand by
itself, btw.  But, this is a small enough patch that it's fine.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

