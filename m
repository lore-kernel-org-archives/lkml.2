Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1ILRYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 13:24:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:16020 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1ILRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 13:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,369,1312182000"; 
   d="scan'208";a="50416174"
Date: Mon, 12 Sep 2011 10:24:07 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Klaus Schwarzkopf <schwarzkopf@sensortherm.de>,
        mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: clean up FSF boilerplate text
Message-ID: <20110912172407.GA8044@xanatos>
References: <1315686255-12892-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110910221045.04953572@lxorguk.ukuu.org.uk>
 <20110911004420.GA3413@suse.de>
 <20110911093625.325b9ea4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911093625.325b9ea4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 09:36:25AM +0100, Alan Cox wrote:
> On Sun, 11 Sep 2011 02:44:20 +0200
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Sat, Sep 10, 2011 at 10:10:45PM +0100, Alan Cox wrote:
> > > On Sat, 10 Sep 2011 22:24:15 +0200
> > > Klaus Schwarzkopf <schwarzkopf@sensortherm.de> wrote:
> > > 
> > > >     remove the following two paragraphs:
> > > 
> > > NAK this for anything containing my copyright. NAK the one about warranty
> > > and liability because its incredibly important, although of course if
> > > you'd like to take personal liability...
> > 
> > Odd, I was told that if you have the "this is covered under the GPLv2"
> > then that's all that is needed for a single file in a larger body of
> > work, like the kernel.
> 
> People regularly take files out of the kernel or display only one of
> them. However it's a legal question which means changing it needs the
> approval of the right subspecies ....
> 
> You may be right, but it should go past the appropriate expert for the
> change, just like anything else.
> 
> > But you do agree about the address paragraph being able to be removed,
> > right?
> 
> <wears parrot outfit>
> That is a legal question. I am not a lawyer. Please discuss with Intel
> before removing any disclaimers other license material.
> </>
> 
> Sqwark!

Alan's probably right at least about the warranty bit, so I'll have to
NAK for the changes to the xHCI driver (which are copyright Intel).
BTW, it would have been nice to be CC'd on the original patch. :)

Sarah Sharp
