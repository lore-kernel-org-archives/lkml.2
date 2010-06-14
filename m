Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0FNPmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:42:01 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41427 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0FNPl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rz1NO2+g5MluR4OnuPotVntakNrlmynidhd9H8k/A+3HvWBrqKOtb6/iVIeZMlrQLM
         HnWFlop2Fc8Y7UMJEvUszAo5TqwTgr3jwHC0EMPtMCJ+Elk5umqvA3ukeOukbQXnnHj4
         YmbUBkXdAOTzS2elAsT+6wdQ1vDi71yFhnOtQ=
Date: Mon, 14 Jun 2010 19:41:51 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Mike Rapoport <mike@compulab.co.il>, Wolfram Sang <w.sang@pengutronix.de>,
       Tejun Heo <tj@kernel.org>, Ryan Mallon <ryan@bluewatersys.com>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       sfr@canb.auug.org.au, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] power: Rename get_current to fix build failure / name
 conflict
Message-ID: <20100614154151.GA20343@oksana.dev.rtsoft.ru>
References: <201005130154.58459.PeterHuewe@gmx.de>
 <4BEB8DC0.4060808@compulab.co.il>
 <201006141712.22248.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201006141712.22248.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 05:12:22PM +0200, Peter Huewe wrote:
> Am Donnerstag 13 Mai 2010 07:27:28 schrieb Mike Rapoport:
> > Peter Huewe wrote:
> > > From: Peter Huewe <peterhuewe@gmx.de>
> > >
> > > This patch changes the name of get_current function pointer to
> > > get_battery_current to resolve a name conflict with the get_current
> > > macro defined in current.h.
> > >
> > > This conflict resulted in a build-failure[1] for the sh4 arch
> > > allyesconfig which is resolved by this patch.
> > >
> > > To be consistent the other function pointers (_voltage,_capacity) were
> > > renamed too.
> > >
> > > Signed-off-by: Peter Huewe <peterhuewe@gmx.de> 
> > Acked-by: Ryan Mallon <ryan@bluewatersys.com>
> > Acked-by: Mike Rapoport <mike@compulab.co.il>
> 
> Unfortunately this build-failure still exists, in Linux-next and hit Linus' 
> Tree :/
> 
> References:
> http://kisskb.ellerman.id.au/kisskb/buildresult/2709436/
> http://kisskb.ellerman.id.au/kisskb/buildresult/2687686/

Thanks for the patch.

As this is not a 2.6.35 regression, and only affects just
a few embedded platforms, I think this can wait for the next
merge window.

So, applied to battery-2.6.git (for -next).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
