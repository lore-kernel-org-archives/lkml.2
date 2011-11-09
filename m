Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1KIQ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:58:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34387 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab1KIQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:58:31 -0500
Date: Wed, 9 Nov 2011 16:58:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109165829.GC4016@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
 <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
 <20111109164211.GA4016@opensource.wolfsonmicro.com>
 <20111109165518.GA13451@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109165518.GA13451@kroah.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:55:18AM -0800, Greg KH wrote:
> On Wed, Nov 09, 2011 at 04:42:12PM +0000, Mark Brown wrote:

> > Someone will need to fix the build breakage from peering at the headers
> > from staging.

> What code is including header files from the staging tree in the rest of
> the kernel?

The mainline ASoC driver for one of these Intel SoCs, can't remember
which one.
