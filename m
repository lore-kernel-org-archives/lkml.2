Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2GYQog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:44:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:3130 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab2GYQof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:44:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186028696"
Date: Thu, 26 Jul 2012 00:44:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Coccinelle <cocci@diku.dk>, Nicolas Palix <npalix@diku.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] coccinelle hung on mini_lock.cocci
Message-ID: <20120725164430.GA2421@localhost>
References: <20120725114216.GA26741@localhost>
 <alpine.DEB.2.02.1207251613420.1818@hadrien>
 <20120725141844.GA761@localhost>
 <alpine.DEB.2.02.1207251641280.1818@hadrien>
 <20120725145011.GA1787@localhost>
 <alpine.DEB.2.02.1207251717300.1818@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207251717300.1818@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 05:19:40PM +0200, Julia Lawall wrote:
> I looked at it a bit more, and I think the timeout is the best solution.
> The big jump backwards is under an if, and the pattern tries to match an
> if up to a return, which tries to go across gotos.  So I think it is just
> a pathologically bad case.

OK, Thanks for looking into this so quickly!  I've added the timeout
shortly after your initial suggestion :)

Thanks,
Fengguang
