Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0CYLe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:34:27 -0400
Received: from mga06.intel.com ([134.134.136.21]:30167 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753642Ab0CYLeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,306,1267430400"; 
   d="scan'208";a="503526662"
Date: Thu, 25 Mar 2010 12:35:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wim@iguana.be
Subject: Re: [PATCH 0/4 v3] RDC321x southbridge and GPIO support
Message-ID: <20100325113512.GA9594@sortiz.org>
References: <201003210106.01673.florian@openwrt.org>
 <20100325112727.GC3720@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325112727.GC3720@sortiz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:27:27PM +0100, Samuel Ortiz wrote:
> Hi Florian,
> 
> On Sun, Mar 21, 2010 at 01:06:01AM +0100, Florian Fainelli wrote:
> > Hi Samuel, Andrew,
> > 
> > This is the third round of the RDC321x southbridge and GPIO support, this 
> > version should hopefully address all of your comments.
> All 4 (I took v2 for the watchdog) patches applies, thanks.
Nevermind, I had to take v3 version for the watchdog, although I couldnt find
it in my inbox.

Cheers,
Samuel.

> 
> Cheers,
> Samuel.
> 
> 
> > Thanks!
> > 
> > Florian Fainelli (4):
> >   MFD: add support for the RDC321x southbridge
> >   GPIO: add support for RDC321x GPIO controller
> >   WATCHDOG: convert rdc321x_wdt to use southbridge pci device
> >   x86: remove rdc321x_defs.h
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
