Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0CZKPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:15:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:4962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab0CZKPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,313,1267430400"; 
   d="scan'208";a="503888512"
Date: Fri, 26 Mar 2010 11:16:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 0/2] mfd, dma: Add timb-dma driver
Message-ID: <20100326101636.GB3237@sortiz.org>
References: <1269542656.9188.37.camel@debian>
 <e9c3a7c21003251735y278a24cagd50474ecaaaab55e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9c3a7c21003251735y278a24cagd50474ecaaaab55e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, Mar 25, 2010 at 05:35:21PM -0700, Dan Williams wrote:
> On Thu, Mar 25, 2010 at 11:44 AM, Richard Röjfors
> <richard.rojfors@pelagicore.com> wrote:
> > To follow are two patches.
> >
> > Samuel and Dan, since the MFD patch relies on the DMA patch.
> > The MFD patch is against Samuels next tree, maybe it is easiest
> > if the DMA driver is merged via Samuels tree?
> 
> It depends on the mfd patch at runtime, but thankfully not at build
> time.  There are some other patches being floated by Linus to change
> the device_terminate_all() and device_is_tx_complete() operations.
> So, I want to take just the driver patch through the dma tree to make
> sure everything stays in sync.
Makes sense. I'll take the MFD patch, thanks for taking care of the dma one.

Cheers,
Samuel.


> Thanks,
> Dan

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
