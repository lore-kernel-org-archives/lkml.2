Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0EPV7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 17:59:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:27109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0EPV7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 17:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,242,1272870000"; 
   d="scan'208";a="518395479"
Date: Mon, 17 May 2010 00:00:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Lars-Peter Clausen <lars@metafoo.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gta02: Use pcf50633 backlight driver instead of
 platform backlight driver.
Message-ID: <20100516220010.GA3236@sortiz.org>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de>
 <1273625074-15312-4-git-send-email-lars@metafoo.de>
 <20100512010211.GL2589@trinity.fluff.org>
 <1273760705.12731.12.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273760705.12731.12.camel@rex>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, May 13, 2010 at 10:25:05PM +0800, Richard Purdie wrote:
> On Wed, 2010-05-12 at 02:02 +0100, Ben Dooks wrote:
> > On Wed, May 12, 2010 at 02:44:34AM +0200, Lars-Peter Clausen wrote:
> > > Use the pcf50633 backlight driver instead of the platform backlight driver.
> > > 
> > > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > > Cc: Ben Dooks <ben-linux@fluff.org>
> > 
> > ok, does anyone else have a comment on this?
> 
> Looks like a sensible idea to me but I'm travelling and don't have time
> to properly review the patches right now.
> 
> The main question is who takes which patches. I can take the main new
> backlight one, the other two I need opinions from the mfd (Samuel) and
> gta02 (?) maintainers...
The MFD patch looks good to me, you can add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.


> Cheers,
> 
> Richard
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
