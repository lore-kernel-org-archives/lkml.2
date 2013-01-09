Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3AIPf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:35:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:2498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab3AIPf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:35:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="189353106"
Date: Wed, 9 Jan 2013 07:11:09 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 11/16] dw_dmac: backlink to dw_dma in
 dw_dma_chan is superfluous
Message-ID: <20130109151108.GS19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-12-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130109142443.GQ19691@intel.com>
 <CAHp75Vfpvd87JP=W=u0CAHhdJinJhCdQHDye_te5+tfjgfKz3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vfpvd87JP=W=u0CAHhdJinJhCdQHDye_te5+tfjgfKz3Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:02:39PM +0200, Andy Shevchenko wrote:
> On Wed, Jan 9, 2013 at 4:24 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Wed, Jan 09, 2013 at 10:17:10AM +0200, Andy Shevchenko wrote:
> >> The same information could be exctracted from the struct dma_chan.
> > typo...                         ^^^^^^^^^^
> 
> Thanks for finding this. Fixed in my local tree.
> Shall I resubmit it here?
Never mind, this is minor one, will fix while applying

--
~Vinod
