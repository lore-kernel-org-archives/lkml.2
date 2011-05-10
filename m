Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1EJIpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:45:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:30974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab1EJIpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,345,1301900400"; 
   d="scan'208";a="690555240"
Date: Tue, 10 May 2011 10:45:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/19] mfd: Use mfd cell platform_data for wm8400 cells
 platform bits
Message-ID: <20110510084500.GB17268@sortiz-mobl>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-13-git-send-email-sameo@linux.intel.com>
 <20110509071341.GA21967@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509071341.GA21967@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, May 09, 2011 at 09:13:42AM +0200, Mark Brown wrote:
> On Mon, May 09, 2011 at 02:32:04AM +0200, Samuel Ortiz wrote:
> 
> >  static int wm8400_codec_probe(struct snd_soc_codec *codec)
> >  {
> > -	struct wm8400 *wm8400 = mfd_get_data(to_platform_device(codec->dev));
> > +	struct wm8400 *wm8400 = codec->dev->platform_data;
> 
> It'd be better to use platform_get_drvdata() here rather than accessing
> the pointer directly.
Is the core codec code setting the driver_data pointer appropriately ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
