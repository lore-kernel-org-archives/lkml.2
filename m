Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab2IMMwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:52:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:21851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757689Ab2IMMwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:52:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,416,1344236400"; 
   d="scan'208";a="192522735"
Date: Thu, 13 Sep 2012 14:52:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd/janz-cmodio: fix MODULBus number sysfs entry
Message-ID: <20120913125201.GB3647@sortiz-mobl>
References: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu>
 <1347404295-7985-2-git-send-email-iws@ovro.caltech.edu>
 <5051C9F0.3050600@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051C9F0.3050600@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:56:32PM +0200, Marc Kleine-Budde wrote:
> On 09/12/2012 12:58 AM, Ira W. Snyder wrote:
> > From: "Ira W. Snyder" <iws@ovro.caltech.edu>
> > 
> > Revision 1.0 of the Janz CMOD-IO Carrier Board does not contain zeroes
> > in the top 4 bits of the modulbus_num (int_enable) register. Mask off
> > the unused bits so that the correct value is displayed in sysfs.
> > 
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> 
> Who will take care of this patch?
I will.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
