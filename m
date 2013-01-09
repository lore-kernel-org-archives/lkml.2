Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab3AIPeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:34:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:37781 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab3AIPeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:34:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="270055320"
Date: Wed, 9 Jan 2013 07:10:01 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 03/16] dmaengine: introduce is_slave_xfer
 function
Message-ID: <20130109151001.GR19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130109135006.GO19691@intel.com>
 <CAKohpokJGXKZ9jonGtYvTnPNLVr=wjhQ0DN_e=PF=U3nvusp-A@mail.gmail.com>
 <CAHp75VdWWy7V=PQ2EfXrixX2==yDiakga=tA=jV9bzRrqqzZhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdWWy7V=PQ2EfXrixX2==yDiakga=tA=jV9bzRrqqzZhw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 04:58:02PM +0200, Andy Shevchenko wrote:
> On Wed, Jan 9, 2013 at 4:19 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > n 9 January 2013 19:20, Vinod Koul <vinod.koul@intel.com> wrote:
> >>> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
> >>> +{
> >>> +     return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
> >>> +}
> >> After reading the subsequent patch I understand what is intent here. Perhaps
> >> is_slave_dirn() would have been a beter one...
> >
> > dirn isn't readable, it took me some time to understand the intent...
> > Either have xfer or direction :)
> 
> Agree with Viresh. I might rename it to is_slave_direction if you want to.
direction sounds fine too.

--
~Vinod
