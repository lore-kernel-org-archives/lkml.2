Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab1EJJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:09:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40906 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782Ab1EJJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:09:58 -0400
Date: Tue, 10 May 2011 11:10:03 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/19] mfd: Use mfd cell platform_data for wm8400 cells
 platform bits
Message-ID: <20110510091002.GB5146@opensource.wolfsonmicro.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-13-git-send-email-sameo@linux.intel.com>
 <20110509071341.GA21967@opensource.wolfsonmicro.com>
 <20110510084500.GB17268@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510084500.GB17268@sortiz-mobl>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:45:01AM +0200, Samuel Ortiz wrote:

> > > -	struct wm8400 *wm8400 = mfd_get_data(to_platform_device(codec->dev));
> > > +	struct wm8400 *wm8400 = codec->dev->platform_data;

> > It'd be better to use platform_get_drvdata() here rather than accessing
> > the pointer directly.

> Is the core codec code setting the driver_data pointer appropriately ?

Sorry, I meant _get_platdata().
