Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1CQKgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:36:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:4406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab1CQKgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,198,1299484800"; 
   d="scan'208";a="668241517"
Subject: Re: linux-next: build failure after merge of the block tree
From: David Woodhouse <david.woodhouse@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>
In-Reply-To: <4D81E010.1090808@kernel.dk>
References: <20110314161919.15e6d983.sfr@canb.auug.org.au>
	 <20110317103218.ca7f63bf.sfr@canb.auug.org.au> <4D81E010.1090808@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Thu, 17 Mar 2011 10:36:10 +0000
Message-ID: <1300358170.2589.50.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 10:18 +0000, Jens Axboe wrote:
> 
> Can you point me at the commit in question? Generally,
> elv_queue_empty()
> can be replaced by blk_peek_request(). 

The interesting commit is this one:
http://git.infradead.org/mtd-2.6.git/commitdiff/c7519dbf6

The point of it is to enable this
http://git.infradead.org/mtd-2.6.git/commitdiff/a32159024

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

