Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424456Ab2LFQes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:34:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42847 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424176Ab2LFQeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:34:46 -0500
Date: Thu, 6 Dec 2012 08:34:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH v6] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121206163440.GB8052@kroah.com>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121116163146.f4b53f6965ee08ca1a1fc96c@tw.synaptics.com>
 <20121116195433.GA573@polaris.bitmath.org>
 <20121116195008.GA9153@kroah.com>
 <CC51EC7B5B7F984AA566DC102237848896F73163@hkdcw-mail2.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F73163@hkdcw-mail2.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 11:30:55AM +0000, Alexandra Chin wrote:
> Hi Greg,
> 
> > > For next time: Once you have received an acked-by or reviewed-by, you
> > > may add that line under your own signed-off-by in subsequent
> > > mails. That way, the status of the patch can be tracked properly,
> > > making life easier for everyone.
> > >
> > > Greg, I think we are ready now. :-)
> > 
> > All applied.
> 
> There are coming patches which needs to be updated and based on this patch,
> but I noticed that this patch has not been submitted in recent mainline
> archives (3.7-rc7/3.7-rc8).

That is because they were new features, and not regressions, so they
will be showing up in Linus's tree for 3.8-rc1.

> May I know status of this patch? Please let me know if there is anything I 
> should do.

Didn't you get an email when I applied the patches saying where the
patches could be seen and when they would be merged to Linus?

thanks,

greg k-h
