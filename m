Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2FPTMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:12:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45727 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab2FPTLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:11:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Sat, 16 Jun 2012 21:17:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <201206161559.30267.rjw@sisk.pl> <20120616173952.GA20623@liondog.tnic>
In-Reply-To: <20120616173952.GA20623@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206162117.08877.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 16, 2012, Borislav Petkov wrote:
> On Sat, Jun 16, 2012 at 03:59:30PM +0200, Rafael J. Wysocki wrote:
> > On Friday, May 25, 2012, Bojan Smojver wrote:
> > > Borislav Petkov <bp@alien8.de> wrote:
> > > 
> > > >Let me ask again, can you send the last version of that patch so that I
> > > >can give it a run pls?
> > > 
> > > 
> > > Sorry. That patch is here (pretty much the original with signed-off):
> > > 
> > > http://marc.info/?l=linux-kernel&m=133651588229850&w=2
> > 
> > Queued up for 3.6 in linux-pm/linux-next.
> 
> IMHO, this one still needs a fix for the progress indicator output
> landing in dmesg and filling it up with \x08 chars:
> 
> http://marc.info/?l=linux-pm&m=133848160403298&w=2

Hmm.  Is there any fix, though?

Rafael
