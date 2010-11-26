Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0KZOHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:07:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35146 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751192Ab0KZOHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:07:21 -0500
Date: Fri, 26 Nov 2010 14:07:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/7] Wolfson MFD updates
Message-ID: <20101126140719.GH30360@rakim.wolfsonmicro.main>
References: <20101124180055.GO24970@rakim.wolfsonmicro.main>
 <20101126140518.GN5520@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126140518.GN5520@sortiz-mobl>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 03:05:19PM +0100, Samuel Ortiz wrote:
> On Wed, Nov 24, 2010 at 06:00:55PM +0000, Mark Brown wrote:

> > This is a reposting of a number of Wolfson MFD patches previously posted
> > - I seem to building up a relatively large queue of patches here.

> > Patch 1/7 is a bugfix and really ought to go into 2.6.37, patch 7/7
> > would ideally be merged via ASoC as the bulk of the support for this
> > device is in the CODEC driver, 2-3 are a new device and 4-6 are some
> > housekeeping for new kernel APIs.

> All 7 patches applied, thanks a lot.

Thanks!

Would it be OK to apply patch 7 to the ASoC tree?  There's a bunch of
CODEC driver changes to support the WM8958 which depend on it and also
depend on changes in the ASoC tree.
