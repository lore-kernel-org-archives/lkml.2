Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1KIQEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:04:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:49410 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1KIQEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:04:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,484,1315206000"; 
   d="scan'208";a="82966406"
Subject: Re: Staging clear up
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111109121329.GC21630@sirena.org.uk>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
	 <20111109121329.GC21630@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 21:30:13 +0530
Message-ID: <1320854413.32205.948.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 12:13 +0000, Mark Brown wrote:
> On Tue, Nov 08, 2011 at 09:16:56PM +0000, Alan Cox wrote:
> 
> > drivers/staging/intel_sst
> 
> > This also appears on Medfield but there is an ASoC driver for the
> > Medfield version and we no longer need to keep this. There were naughty
> > bits of code peeking into staging for files but that should now be sorted
> > (and if not they need to break and be forced to fix them)
> 
> There was also all the compressed audio offload stuff in there which
> is useful but isn't integrated yet.  Vinod posted a version of the
> generic compressed API but work seems to have stalled again.
I have a reworked version of this driver which uses the new compressed
API, I am planning to get that in mainline by 3.3

Yes work is slow but not stalled :(

Alan, if you folks are not using the staging driver I am okay for its
removal

-- 
~Vinod

