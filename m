Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab2HUVqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:46:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:54364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482Ab2HUVqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:46:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,804,1336374000"; 
   d="scan'208";a="183666593"
Date: Tue, 21 Aug 2012 14:46:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Ben Hutchings <ben@decadent.org.uk>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Memory policy corruption fixes V2
Message-ID: <20120821214636.GA12707@tassilo.jf.intel.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345480594-27032-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tested this with trinity with CONFIG_DEBUG_SLAB enabled and it passed. I
> did not test LTP such as Josh reported a problem with or with a database that
> used shared policies like Andi tested. The series is almost all Kosaki's
> work of course. If he has a revised series that simply got delayed in
> posting it should take precedence.

Initial tests of this patchkit look with a test programgood, full database tests 
are still pending.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
