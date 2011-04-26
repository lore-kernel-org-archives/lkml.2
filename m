Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1DZAtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:49:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:32828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab1DZAtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:49:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="738325590"
Subject: Re: [RFC]block: add flush request at head
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110425082103.GA17734@mtj.dyndns.org>
References: <1303112174.3981.187.camel@sli10-conroe>
	 <4DABF194.4010603@fusionio.com> <1303115157.3981.198.camel@sli10-conroe>
	 <20110422225704.GA1576@mtj.dyndns.org>
	 <1303693319.3981.272.camel@sli10-conroe>
	 <20110425082103.GA17734@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 08:49:15 +0800
Message-ID: <1303778955.3981.285.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 16:21 +0800, Tejun Heo wrote:
> Hello, Shaohua.
> 
> On Mon, Apr 25, 2011 at 09:01:59AM +0800, Shaohua Li wrote:
> > this is a regression from 2.6.39-rc2 compared to 2.6.39-rc1, so this
> > isn't related to the flush rewritten. Workload is sysbench fileio,
> > please see the first mail at the thread for detail.
> 
> Understood.  Let's talk on the other thread.
This issue isn't related to the optimization patch in another thread.
And that patch can't recover the regression, which does improve
throughput even without the regression. So please look at issue again.

Thanks,
Shaohua


