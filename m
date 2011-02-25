Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1BYD6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:58:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:41355 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1BYD6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:58:06 -0500
Date: Thu, 24 Feb 2011 19:58:57 -0800
From: Greg KH <gregkh@suse.de>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Kenneth Heitke <kheitke@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        tsoni@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface (SSBI)
 driver
Message-ID: <20110225035857.GA9985@suse.de>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
 <1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
 <1298600621.17118.27.camel@m0nster>
 <8yad3mgdeut.fsf@huya.qualcomm.com>
 <1298601346.17118.29.camel@m0nster>
 <AANLkTikD1Ued=rit1QbMWwe3NGFz2iQ-KO7B=-N6Ok-2@mail.gmail.com>
 <8ya8vx4dcky.fsf@huya.qualcomm.com>
 <20110225032856.GA8475@suse.de>
 <8yavd08bwgi.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yavd08bwgi.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 07:54:21PM -0800, David Brown wrote:
> On Thu, Feb 24 2011, Greg KH wrote:
> 
> > drivers/ssbi?  What's keeping this from later moving off of the msm
> > chips to run on others?  USB started out only on one processor, as did a
> > lot of other bus-specific drivers, before the hardware became present on
> > other architectures.  So no need to bury it under a msm specific
> > location.
> 
> Not sure if anything is stopping it from moving off of MSM chips, but it
> doesn't seem very likely.  There are too many similar interfaces that
> are standard that others would be likely to use.  For the most part, it
> is the bus to communicate between the MSM and it's specialized
> peripherals.
> 
> We can still put it there, but it will likely be the only driver ever in
> the directory.

Ah, so it's just one driver?  Then how about drivers/platform/msm/ ?

thanks,

greg k-h
