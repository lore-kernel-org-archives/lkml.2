Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KASiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:38:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:38320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab0KASip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:38:45 -0400
Date: Mon, 1 Nov 2010 11:39:18 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 03/10] staging: hv: Convert camel cased struct fields
	in hv.h to lower cases
Message-ID: <20101101183918.GA453@suse.de>
References: <1288630429-12330-1-git-send-email-haiyangz@linuxonhyperv.com> <20101101174310.GA12632@suse.de> <1FB5E1D5CA062146B38059374562DF728BA19E86@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF728BA19E86@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 06:27:04PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Monday, November 01, 2010 1:43 PM
> > Why did I get two different copies of some of these patches?  Are they
> > different?
> 
> They are the same.
> Initially, I sent all 10 patches out at the same time, but I only saw 5 of them in my mail box. So I re-sent the 5 missing ones. Half hour later, I found the 5 previous missing emails were not lost, and received again at a later time.

Ah, ok.

Oh, please wrap your emails properly :)

> > >  /* The one and only */
> > > -struct hv_context gHvContext = {
> > > -	.SynICInitialized	= false,
> > > -	.HypercallPage		= NULL,
> > > -	.SignalEventParam	= NULL,
> > > -	.SignalEventBuffer	= NULL,
> > > +struct hv_context g_hv_context = {
> > 
> > What is the "g_" for?  Why are you keeping the unneeded, and unwanted
> > hungarian notation around?  Please don't do that.
> 
> The "g_" was used for global variables. I also saw some other global
> variables with the hungarian notation. Since this notation is not
> related to camel case conversion, how about we remove the hungarian
> notations in a separate patch?

How about you fix this patch in the series and resend them?

And if you look at the kernel, there is no "g_" for global variable
names, so I don't want to see that as part of the history at all.

I'll drop these series and wait for an updated one.

thanks,

greg k-h
