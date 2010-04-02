Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab0DBKRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:17:23 -0400
Received: from mga05.intel.com ([192.55.52.89]:53055 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756045Ab0DBKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:17:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="554437222"
Date: Fri, 2 Apr 2010 12:17:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add WM8994 interrupt controller support
Message-ID: <20100402101754.GD8010@sortiz.org>
References: <1269894525-21530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100330141201.GA17007@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330141201.GA17007@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Mar 30, 2010 at 03:12:02PM +0100, Mark Brown wrote:
> On Mon, Mar 29, 2010 at 09:28:45PM +0100, Mark Brown wrote:
> 
> > +	printk(KERN_CRIT "%x %x\n", status[0], status[1]);
> 
> Clearly this is debug code and shouldn't be there in an actual version.
> I'll remove this when resubmitting after review & merge path are sorted
> out.
All right, I won't merge it for now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
