Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1KIXL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:11:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab1KIXL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:11:27 -0500
Date: Wed, 9 Nov 2011 23:11:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109231124.GC17769@opensource.wolfsonmicro.com>
References: <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
 <20111109164211.GA4016@opensource.wolfsonmicro.com>
 <20111109165518.GA13451@kroah.com>
 <20111109165829.GC4016@opensource.wolfsonmicro.com>
 <20111109173037.66bea268@lxorguk.ukuu.org.uk>
 <20111109225933.GA17769@opensource.wolfsonmicro.com>
 <20111109230318.1168fd9e@lxorguk.ukuu.org.uk>
 <20111109230329.GB17769@opensource.wolfsonmicro.com>
 <20111109230558.2fb94c0b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109230558.2fb94c0b@lxorguk.ukuu.org.uk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:05:58PM +0000, Alan Cox wrote:

> Yes - then it doesn't compile. The codec is calling functions defined in
> that header. I don't think you need much of it but both bits of that
> driver are using some of the stuff.

Oh, actually the mainline CODEC driver doesn't have any such staging
references in it at all.  I don't know what tree you're patching
against?
