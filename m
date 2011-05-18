Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab1ERQXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:23:46 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56415 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932877Ab1ERQXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:23:45 -0400
X-Sasl-enc: rHC+edKi/IP+qyJ/EsLC6ac/94BNH2n+KfHDT+QyKAir 1305735824
Date: Wed, 18 May 2011 09:23:38 -0700
From: Greg KH <greg@kroah.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Olaf Hartmann <o.hartmann@telovital.com>
Subject: Re: [RFC/RFT PATCH] Staging: et131x: add suspend/resume support
Message-ID: <20110518162338.GC23079@kroah.com>
References: <1305724667-2980-1-git-send-email-herton.krzesinski@canonical.com>
 <20110518152428.GA8106@kroah.com>
 <20110518160316.GA3502@herton-IdeaPad-Y430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518160316.GA3502@herton-IdeaPad-Y430>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 01:03:17PM -0300, Herton Ronaldo Krzesinski wrote:
> On Wed, May 18, 2011 at 08:24:28AM -0700, Greg KH wrote:
> > On Wed, May 18, 2011 at 10:17:47AM -0300, Herton Ronaldo Krzesinski wrote:
> > > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> > 
> > I think we need a bit more comments here.
> > 
> > Like have you tested this to verify that it works?  Anything else?
> 
> An user complained about lack of suspend/resume support, so I did the
> patch, it's working accordingly to him from what I could get
> (unfortunately I can't test myself, don't have the hardware). I want
> others to test too, before this can be pushed (RFT on subject). The bug
> report I got: http://bugs.launchpad.net/bugs/766549
> But good luck in parsing that... I also want others with same
> hardware testing this, to confirm it is ok.

Ok, then please say so in the patch body itself next time.

I'll wait for you to get some testing, and then resend the patch, before
applying it.

thanks,

greg k-h
