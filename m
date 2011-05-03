Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1ECIdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:33:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:25985 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1ECIdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,308,1301900400"; 
   d="scan'208";a="429404943"
Date: Tue, 3 May 2011 10:33:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add ASIC3 LED support
Message-ID: <20110503083339.GK8222@sortiz-mobl>
References: <20110502153951.GH8222@sortiz-mobl>
 <325376.71935.qm@web29015.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <325376.71935.qm@web29015.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, May 02, 2011 at 11:16:23PM +0100, Paul Parsons wrote:
> Hi Samuel,
> 
> --- On Mon, 2/5/11, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Where is the LED driver ?
> It was posted separately - [PATCH 2/2] leds: Add ASIC3 LED support - since drivers/mfd and drivers/leds are maintained separately. Sorry, I should have cross copied them.
> 
I believe the LED driver is dependent on the asic3.h changes this patches
carry. So both patches should go in at the same time, probably through my
tree. 


> > > -static int asic3_clk_enable(struct asic3 *asic,
> > struct asic3_clk *clk)
> > > +static void asic3_clk_enable(struct asic3 *asic,
> > struct asic3_clk *clk)
> > Although a valid change, this is unrelated to this patch.
> Not completely unrelated; I call asic3_clk_enable() and found it simpler to remove the unnecessary return value rather than check it.
> 
I understood that. And I am fine with the change, but I would like it to be a
separate patch.


> > > +    asic->gpio.label = "asic3";
> > Ditto.
> Agreed; that was left in by mistake.
> 
> Should I resubmit?
Yes, please. Also, I'm deprecating the mfd_data usage in my mfd-2.6 tree, so
you should fix your code according to that.

Thanks in advance.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
