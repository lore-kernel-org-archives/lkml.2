Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab2EUIpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:45:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36832 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2EUIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:45:45 -0400
Date: Mon, 21 May 2012 10:45:39 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add r_select to lm3533 platform data
Message-ID: <20120521084539.GB21033@localhost>
References: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
 <20120520131337.GU12015@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120520131337.GU12015@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 03:13:37PM +0200, Samuel Ortiz wrote:
> Hi Johan,
> 
> On Fri, May 18, 2012 at 08:22:45PM +0200, Johan Hovold wrote:
> > Add resistor-select parameter to the platform data.
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> > 
> > Hi Samuel, 
> > 
> > I believe this one needs to go in through mfd as the iio driver
> > destined for staging-next depends on it.
> It should go along with the iio driver if there is a build dependency.
> No doing so will prevent the tree from being bisectable.

The sub-drivers already depend on mfd to build as this is where the
header file resides. I can't add another platform data parameter via
staging-next simply because the header file isn't in that tree yet.

As long as mfd is merged first linus' tree will be bisectable.

Thanks,
Johan
