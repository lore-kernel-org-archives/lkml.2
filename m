Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab0EDRf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:35:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab0EDRfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:35:55 -0400
Date: Tue, 4 May 2010 19:35:15 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/2] Fix migration races in rmap_walk() V3
Message-ID: <20100504173515.GA854@random.random>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie>
 <20100430182853.GK22108@random.random>
 <20100501135110.GP20640@cmpxchg.org>
 <20100503153301.GD19891@random.random>
 <20100503234132.GK5336@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503234132.GK5336@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 01:41:32AM +0200, Johannes Weiner wrote:
> Although not strictly required, it's probably nicer to keep the
> function signatures in this code alike.  So everything fine with
> me as it stands :)

Too late I already optimized mincore...
