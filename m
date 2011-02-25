Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1BYAVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:21:40 -0500
Received: from kroah.org ([198.145.64.141]:51774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab1BYAVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:21:39 -0500
Date: Thu, 24 Feb 2011 16:13:15 -0800
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>, Greg KH <gregkh@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [Stable-review] [28/70] staging: brcm80211: bugfix for
 softmac crash on multi cpu configurations
Message-ID: <20110225001315.GC24813@kroah.com>
References: <20110222221839.853712243@clark.kroah.org>
 <1298427787.2211.498.camel@localhost>
 <op.vrciafbg3ri7v4@arend-laptop>
 <20110223180627.GB30106@suse.de>
 <op.vrdhl9qk3ri7v4@arend-laptop>
 <4D6658D7.1010501@broadcom.com>
 <20110224182133.GA18081@suse.de>
 <op.vrfddzvf3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vrfddzvf3ri7v4@arend-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:47:49PM +0100, Arend van Spriel wrote:
> On Thu, 24 Feb 2011 19:21:33 +0100, Greg KH <gregkh@suse.de> wrote:
> 
> >
> >Ok, I'm going to drop this patch now.
> >
> >Can someone create the needed patches for the .37-stable tree that
> >should be included and send them to me and cc: stable@kernel.org so I
> >can queue them up for the next .37-stable release after this?
> >
> 
> Hi Greg,
> 
> I sent both patches to you.

Thanks, I got them, I'll queue them up for the next .37-stable release.

greg k-h
