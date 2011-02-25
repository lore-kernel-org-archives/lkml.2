Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1BYDa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:30:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:40858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab1BYDaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:30:55 -0500
Date: Thu, 24 Feb 2011 19:28:56 -0800
From: Greg KH <gregkh@suse.de>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Kenneth Heitke <kheitke@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        tsoni@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface (SSBI)
 driver
Message-ID: <20110225032856.GA8475@suse.de>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
 <1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
 <1298600621.17118.27.camel@m0nster>
 <8yad3mgdeut.fsf@huya.qualcomm.com>
 <1298601346.17118.29.camel@m0nster>
 <AANLkTikD1Ued=rit1QbMWwe3NGFz2iQ-KO7B=-N6Ok-2@mail.gmail.com>
 <8ya8vx4dcky.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ya8vx4dcky.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 07:20:45PM -0800, David Brown wrote:
> On Thu, Feb 24 2011, Dima Zavin wrote:
> 
> > On that note, should we have a "drivers/arm/msm" instead of just
> > "drivers/msm"? Other non-msm arm sub-arches probably have the same
> > problem and polluting drivers/ top-level for every arm-subarch maybe
> > undesirable.
> 
> I'm moving linux-kernel to the 'to' field, and adding Greg KH to CC.
> 
> This is about a new driver (ssbi) for the MSM chips, and where the
> driver for this should go.  The driver is specific to MSM chips (as far
> as I know, the bus is only supported there).  There are likely to be
> future msm-specific drivers, so the suggestion was to put this under
> drivers/msm, or possibly drivers/arm/msm.
> 
> Anyone other suggestions, or preferences for the location?

drivers/ssbi?  What's keeping this from later moving off of the msm
chips to run on others?  USB started out only on one processor, as did a
lot of other bus-specific drivers, before the hardware became present on
other architectures.  So no need to bury it under a msm specific
location.

Hope this helps,

greg k-h
