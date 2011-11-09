Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1KIXDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:03:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab1KIXDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:03:32 -0500
Date: Wed, 9 Nov 2011 23:03:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109230329.GB17769@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
 <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
 <20111109164211.GA4016@opensource.wolfsonmicro.com>
 <20111109165518.GA13451@kroah.com>
 <20111109165829.GC4016@opensource.wolfsonmicro.com>
 <20111109173037.66bea268@lxorguk.ukuu.org.uk>
 <20111109225933.GA17769@opensource.wolfsonmicro.com>
 <20111109230318.1168fd9e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109230318.1168fd9e@lxorguk.ukuu.org.uk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:03:18PM +0000, Alan Cox wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > ..this can hopefully just be removed completely, if it's needed that
> > seems wrong.

> Thats for the SoC audio people to sort out. It means we can now blow away
> the staging stuff

That'd be me, then...  Have you at least tried removing the header
completely?
