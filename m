Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0K2NRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:17:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0K2NRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:17:07 -0500
Date: Mon, 29 Nov 2010 08:16:26 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
Message-ID: <20101129131626.GF15818@bombadil.infradead.org>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie>
 <1288169256-7174-2-git-send-email-mel@csn.ul.ie>
 <20101126160619.GP22651@bombadil.infradead.org>
 <20101129095618.GB13268@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129095618.GB13268@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 09:56:19AM +0000, Mel Gorman wrote:
> Can you point me at a relevant bugzilla entry or forward me the bug report
> and I'll take a look?
> 

https://bugzilla.redhat.com/show_bug.cgi?id=649694

Thanks,
	Kyle
