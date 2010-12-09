Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0LITZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:25:49 -0500
Received: from kroah.org ([198.145.64.141]:44359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab0LITZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:25:47 -0500
Date: Thu, 9 Dec 2010 11:13:56 -0800
From: Greg KH <greg@kroah.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [stable] [PATCH] avr32: Fix build failure conflicting types
 for 'sys_execve'
Message-ID: <20101209191356.GA26183@kroah.com>
References: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
 <20101209182132.GB24175@kroah.com>
 <201012091942.36508.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201012091942.36508.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 07:42:36PM +0100, Peter Hüwe wrote:
> > This is _not_ how to get stuff into the stable kernel tree, sorry.
> Sorry about that - still learning ;) - thanks for your patience.
> 
> > Please read Documentation/stable_kernel_rules.txt for how to do so.
>  It states: "You must note the upstream commit ID in the changelog of your 
> submission." - where do I get the ID from?

That would be if the patch was in Linus's tree already.  Read the next
paragraph in the document:

 - To have the patch automatically included in the stable tree, add the tag
     Cc: stable@kernel.org
   in the sign-off area. Once the patch is merged it will be applied to
   the stable tree without anything else needing to be done by the author
   or subsystem maintainer.

> > Care to resend?
> Will do.
> Or should I rather drop the patch and we wait on Hans-Christian's patch(es)?

Whatever will end up in Linus's tree is the correct thing from a stable
point of view.

thanks,

greg k-h
