Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0JURNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:13:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:46437 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0JURNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,218,1286175600"; 
   d="scan'208";a="338882343"
Date: Thu, 21 Oct 2010 19:16:00 +0200
From: Andi Kleen <ak@linux.intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix array overflow in CFQ
Message-ID: <20101021171600.GA6277@gargoyle.fritz.box>
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
 <4CBD6C84.3020309@kernel.dk>
 <20101019114933.GA857@redhat.com>
 <20101019123320.GB857@redhat.com>
 <4CBD9BCA.2060200@linux.intel.com>
 <20101019150516.GE857@redhat.com>
 <x49fwvz1o8c.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49fwvz1o8c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Agreed.
> >
> > Jens, do you want me to regenerate your patch so that we increase the
> > size of ->busy_queues_avg[CFQ_PRIO_NR] but not ->service_trees[][].
> 
> Just be sure to put a huge comment in there so you don't confuse the
> poor masses trying to make sense of the code.

Right now the code is confusing, with a correctly sized array it would
be completely straight forward.

-Andi
