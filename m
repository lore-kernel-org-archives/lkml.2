Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2DSQIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:08:13 -0400
Received: from relay.sigmatic.fi ([80.69.161.51]:58321 "EHLO relay.sigmatic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab2DSQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:08:12 -0400
Date: Thu, 19 Apr 2012 19:06:50 +0300
From: Hannu Heikkinen <hannuxx@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>
Subject: Re: [PATCH v2] spi/ep93xx: clean probe/remove routines
Message-ID: <20120419160650.GD3437@beyadr.localdomain>
References: <1334818807-4473-1-git-send-email-hannuxx@iki.fi>
 <ADE657CA350FB648AAC2C43247A983F00206987A4555@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206987A4555@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/12 11:03 -0500, H Hartley Sweeten wrote:
> On Thursday, April 19, 2012 12:00 AM, Hannu Heikkinen wrote:
> >
> > Use devm_* functions for managing devres resources.
> >
> > Also use local variable irq and remove irq variable from
> > struct ep93xx_spi, as it is needed only in probe routine.
> >
> > Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
> > Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> Oops.. My bad. My sign off should be:
> 
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

No problem, I just made v3. I was thinking about if you meant Acked/Reviewd-by,
but v3 should be fine!

br,
Hannu

