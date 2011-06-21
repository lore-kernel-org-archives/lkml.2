Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1FUURe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:17:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35869 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab1FUURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:17:32 -0400
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP
 configurable
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <1308667461.11430.315.camel@nimitz>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com>
	 <1308643849-3325-2-git-send-email-amwang@redhat.com>
	 <1308667461.11430.315.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 13:17:00 -0700
Message-ID: <1308687420.11430.330.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Urg.  Pasted the wrong thing.  Should be:

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com> 

-- Dave

