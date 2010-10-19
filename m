Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab0JSKwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:52:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:18487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab0JSKwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:52:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="618147194"
Date: Tue, 19 Oct 2010 12:52:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: Add WM831x SPI support
Message-ID: <20101019105232.GN2736@sortiz-mobl>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1286573003-13889-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20101019094422.GG2736@sortiz-mobl>
 <20101019095347.GC11371@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019095347.GC11371@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Oct 19, 2010 at 02:53:54AM -0700, Mark Brown wrote:
> On Tue, Oct 19, 2010 at 11:44:23AM +0200, Samuel Ortiz wrote:
> 
> > > +static int wm831x_spi_write_device(struct wm831x *wm831x, unsigned short reg,
> > > +				   int bytes, void *src)
> > > +{
> > > +	struct spi_device *spi = wm831x->control_data;
> > > +	u16 *s = src;
> > > +	u16 data[2];
> > > +	int ret;
> > > +
> > > +	/* Go register at a time */
> > > +	for (r = reg; r < reg + (bytes / 2); r++) {
> > > +		data[0] = r;
> 
> Oh, gah.  We need an extra int r here, I've obviously stuffed up the
> move from the BSP I was working on.  Sorry about that:
No problem, I didn't see it as I haven't build my tree yet.
I squashed this fix into the initial patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
