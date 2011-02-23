Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1BWSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:09:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1BWSJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:09:26 -0500
Date: Wed, 23 Feb 2011 10:06:27 -0800
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Roland Vossen <rvossen@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [28/70] staging: brcm80211: bugfix for softmac
 crash on multi cpu configurations
Message-ID: <20110223180627.GB30106@suse.de>
References: <20110222221839.853712243@clark.kroah.org>
 <1298427787.2211.498.camel@localhost>
 <op.vrciafbg3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vrciafbg3ri7v4@arend-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 08:40:53AM +0100, Arend van Spriel wrote:
> On Wed, 23 Feb 2011 03:23:07 +0100, Ben Hutchings
> <ben@decadent.org.uk> wrote:
> 
> >On Tue, 2011-02-22 at 14:17 -0800, Greg KH wrote:
> >>2.6.37-stable review patch.  If anyone has any objections,
> >>please let us know.
> >>
> >>------------------
> >
> >Why is this so different?
> >
> 
> Hi Ben,
> 
> I think you are right. The diff below actually is from another
> commit which I posted for stable review titled:
> 
> staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel

So, what should I do here?  Drop the referenced patch from the
.37-stable queue, or do you have the text for the changelog that I
should use here instead?

confused,

greg k-h
