Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1CIQ1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:27:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab1CIQ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:27:40 -0500
Date: Wed, 9 Mar 2011 08:00:46 -0800
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        Brett Rudley <brudley@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi switch
 to OFF
Message-ID: <20110309160046.GA30821@suse.de>
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
 <op.vr2jgfwg3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vr2jgfwg3ri7v4@arend-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:03:41AM +0100, Arend van Spriel wrote:
> On Sat, 05 Mar 2011 18:11:20 +0100, Francis Moreau
> <francis.moro@gmail.com> wrote:
> 
> >Hi,
> >
> >I'm currently running 2.6.38-rc6, and if I boot with my WIFI switch
> >set to off position, the system freezes entirely when bringing up the
> >wlan0 interface.
> >
> >There's no trace so I don't really know how I can help to debug
> >this further.
> >
> >Thanks
> 
> Hi Greg,
> 
> A while ago I submitted a patch for this issue and it was marked as
> new functionality so only to be included in the staging-next branch.
> However, as the system freezes without this patch it might be a good
> idea to submit the patch for staging-linus branch as well to include
> it in linus tree. Do you agree? If so I will prepare a backported
> version of the patch and send it to you.

Sure, but I will wait and add it to the stable releases when it goes
into Linus's tree.  Sound ok?

thanks,

greg k-h
