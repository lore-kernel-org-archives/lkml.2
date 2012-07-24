Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2GXHsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 03:48:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:33124 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2GXHss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 03:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="184762575"
Date: Tue, 24 Jul 2012 15:48:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John David Anglin <dave.anglin@bell.net>
Cc: Mel Gorman <mgorman@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
Message-ID: <20120724074844.GA9519@localhost>
References: <20120722163058.GB13376@localhost>
 <20120723111619.GT9222@suse.de>
 <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
 <20120723114258.GV9222@suse.de>
 <20120723122905.GA22476@localhost>
 <BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be easier to see what's happening with preprocessed source.

Here is the line in sock.i:

struct static_key memalloc_socks = ((struct static_key) { .enabled = ((atomic_t) { (0) }) });

Thanks,
Fengguang
