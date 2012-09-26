Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2IZMda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:33:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:1432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab2IZMd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="227031947"
Message-ID: <1348662802.13371.142.camel@smile>
Subject: Re: [PATCHv1 1/6] dmaengine: dw_dmac: Remove clk API dependency
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 26 Sep 2012 15:33:22 +0300
In-Reply-To: <CAOh2x=mhHzGennpHCnwHOG3rmNXv4NuK4ExSe0Se45zCowicnQ@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348575190-11761-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=mhHzGennpHCnwHOG3rmNXv4NuK4ExSe0Se45zCowicnQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 09:12 +0530, viresh kumar wrote: 
> On Tue, Sep 25, 2012 at 5:43 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Not all platforms support clk API.

> But not these. There are dummy clk routines available now for platforms which
> don't support clk framework. So, even if your platform doesn't support clk
> framework, you should be able to compile your code.
I have tested without this patch. Works nicely.
I'm about to submit patch v2.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
