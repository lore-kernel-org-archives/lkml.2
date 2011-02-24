Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1BXSWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:22:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1BXSWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:22:37 -0500
Date: Thu, 24 Feb 2011 10:21:33 -0800
From: Greg KH <gregkh@suse.de>
To: Roland Vossen <rvossen@broadcom.com>
Cc: Arend Van Spriel <arend@broadcom.com>, Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [28/70] staging: brcm80211: bugfix for softmac
 crash on multi cpu configurations
Message-ID: <20110224182133.GA18081@suse.de>
References: <20110222221839.853712243@clark.kroah.org>
 <1298427787.2211.498.camel@localhost>
 <op.vrciafbg3ri7v4@arend-laptop>
 <20110223180627.GB30106@suse.de>
 <op.vrdhl9qk3ri7v4@arend-laptop>
 <4D6658D7.1010501@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6658D7.1010501@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 02:10:47PM +0100, Roland Vossen wrote:
> Hi Greg,
> 
> >>So, what should I do here?  Drop the referenced patch from the
> >>.37-stable queue, or do you have the text for the changelog that I
> >>should use here instead?
> >>
> >>confused,
> >>
> >
> >Dito here. I submitted a patch for the stable kernel and Roland did one
> >(if I am correct). I have no clue how his commit message came with my
> >patch or vice versa.
> >
> 
> Let me try to clear up part of the confusion.
> 
> The short story is: for some mysterious reason, a patch exists that
> is a mixup of two patches (one from Arend and one from me). It
> contains the commit message from me, but the file changes from
> Arend. This 'hybrid' patch was submitted for review by you. This
> patch did not make it yet into the 2.6.37-stable tree.
> 
> Also, neither Arends nor my Patch ended up in the 2.6.37-stable tree.
> 
> To fix this problem, I think that this hybrid patch has to be review
> rejected. Next, new patches have to be created based on Rolands
> patch (6a3be6e6e7feb4cb35275475d6a863b748d59cc3, as submitted into
> gregkh/staging-2.6.git::staging-linus branch) as well as Arends
> patch (d062d44a8386c82c06e483f0c0d1124ba3cab2c8). These patches
> would then have to be reviewed for the 2.6.37-stable tree.

Ok, I'm going to drop this patch now.

Can someone create the needed patches for the .37-stable tree that
should be included and send them to me and cc: stable@kernel.org so I
can queue them up for the next .37-stable release after this?

thanks,

greg k-h
