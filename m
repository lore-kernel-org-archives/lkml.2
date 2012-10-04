Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2JDGvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:51:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45809 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2JDGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:51:42 -0400
Date: Wed, 3 Oct 2012 23:51:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH] Input: Add new driver into Input Subsystem for Synaptics
 DS4 touchscreen I2C devices
Message-ID: <20121004065137.GA14217@core.coreip.homeip.net>
References: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
 <20121003180121.GA4198@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F593FA@hkdcw-mail1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F593FA@hkdcw-mail1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

On Thu, Oct 04, 2012 at 05:52:45AM +0000, Alexandra Chin wrote:
> From: Henrik Rydberg
> Sent: Thursday, October 04, 2012 2:01 AM
> > It seems this driver is already present in staging. Comments and
> > formatting have been improved in the staging version, but that aside,
> > the two versions look very similar.  Why don't you submit fixes to
> > that driver instead?
> 
> > On a general note, both versions of the driver use MT-A. Please
> > convert to MT-B, using the in-kernel tracking if necessary.
> 
> 
> Hi Henrik,
> 
> Appreciate your suggestion!
> We are going to update a patch of using MT-B, because Synaptics devices are 
> capable of tracking identifiable contacts (type B).
> Thanks for pointing out this.
> 
> You are right, there is already a synaptics_i2c_rmi4 driver in staging 
> state (drivers/staging/ste_rmi4). 
> Actually synaptics_ds4_i2c driver is developed based on synaptics_i2c_rmi4 
> driver. The point is that we would want to make a clear definition that 
> synaptics_ds4_i2c only targets to DS4 family, so that we can keep maintaining 
> driver focusing on DS4 product line (not all Synaptics touchscreen devices are 
> DS4 compatible).

Given that the other group at Synaptics works on general version of RMI4
driver what is the benefit of having separate driver for DS4 line? I can
understand keeping one copy of older driver in staging so that some
customers coudl still use hardware while universal implementation is
being developed, but I do not see why we would want to have 3 separate
drivers.

Thanks.

-- 
Dmitry
