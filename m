Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1CWPFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:05:24 -0400
Received: from kroah.org ([198.145.64.141]:52553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab1CWPFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:05:21 -0400
Date: Wed, 23 Mar 2011 08:04:13 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323150413.GC6284@kroah.com>
References: <4D79F068.2080009@linaro.org>
 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
 <1300828125.2402.300.camel@pasglop>
 <4D8924B6.8040403@linaro.org>
 <1300842219.2402.309.camel@pasglop>
 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>
 <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
 <20110323093847.55e9dbba@lxorguk.ukuu.org.uk>
 <20110323105335.GB778@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323105335.GB778@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:53:35AM +0000, Mark Brown wrote:
> In the specific case of MACs and device names for network adaptors we
> have userspace solutions which are obscuring the discussion but there
> are other things which get configured this way which one would usually
> expect to be handled in kernel.

No, this isn't obsucuring the discussion, it's exactly the point here.

I asked for concrete examples of a need for this type of thing (i.e.
platform data on USB devices), and this was the only need cited.  I
then pointed out that this is correctly solved in userspace, as it has
for other devices like this, and that it's not a valid example of this
need.

So again, this problem, for this device, has been solved in userspace
without any kernel changes needed.  If there are other devices that you,
or anyone else, feels needs platform data in a USB device, please point
them out to me, and I will be glad to address them in a case-by-case
basis as done here.

thanks,

greg k-h
