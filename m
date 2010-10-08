Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0JHKr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:47:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:14822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0JHKrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:47:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="561904707"
Date: Fri, 8 Oct 2010 18:27:09 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: "Wu, Xia" <xia.wu@intel.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] bdi: use deferable timer for sync_supers task
Message-ID: <20101008102709.GA12682@ywang-moblin2.bj.intel.com>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com> <20101008092520.GB5426@lst.de> <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com> <1286532586.2095.55.camel@localhost> <A24AE1FFE7AEC5489F83450EE98351BF227AB58D51@shsmsx502.ccr.corp.intel.com> <1286533687.2095.58.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286533687.2095.58.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 01:28:07PM +0300, Artem Bityutskiy wrote:
> On Fri, 2010-10-08 at 18:27 +0800, Wu, Xia wrote:
> > > However, when the next wake-up interrupt happens is not defined. It can
> > > happen 1ms after, or 1 minute after, or 1 hour after. What Christoph
> > > says is that there should be some guarantee that sb writeout starts,
> > > say, within 5 to 10 seconds interval. Deferrable timers do not guarantee
> > > this. But take a look at the range hrtimers - they do exactly this.
> > 
> > If the system is in sleep state, is there any data which should be written?
> 
> May be yes, may be no.
> 

Thanks for the quick response, Artem. May I know what might need to be
written out when system is really idle?

-Yong

