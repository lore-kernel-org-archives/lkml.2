Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab0J1Rzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:55:47 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:46123 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753828Ab0J1Rzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:55:43 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Greg KH <greg@kroah.com>
Subject: Re: How do I add yaffs file system to mainline?
Date: Fri, 29 Oct 2010 06:55:39 +1300
User-Agent: KMail/1.9.10
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <201010290455.02390.manningc2@actrix.gen.nz> <20101028102641.d936aec8.randy.dunlap@oracle.com> <20101028174432.GA2001@kroah.com>
In-Reply-To: <20101028174432.GA2001@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010290655.39490.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 October 2010 06:44:32 Greg KH wrote:
> On Thu, Oct 28, 2010 at 10:26:41AM -0700, Randy Dunlap wrote:
> > On Fri, 29 Oct 2010 04:55:02 +1300 Charles Manning wrote:
> > > YAFFS has been used for many years as a third-party patch-in.
> > >
> > > I have recently been through the exercise of changing all the symbols
> > > to be more kernel friendly with the intention of mainlining into the
> > > linux tree.
> > >
> > > The code is in git at
> > > http://github.com/cdhmanning/linux-yaffs-integration/
> >
> > It's difficult to review & comment on a git tree.
> > We prefer patches via email for review.
> >
> > > Thanks to CELF and Google for sponsoring the effort so far.
> > >
> > > What still needs to be done to mainline this?
> > > Who do I need to approach?
> >
> > Either ask Stephen Rothwell to add the git tree to the linux-next daily
> > tree or ask Greg KH to add it to the drivers/staging/ area.
>
> I'd be glad to add the code to the staging tree, but to do so, do you
> have a list of things that are left to do in order to get it properly
> merged to the "real" portion of the kernel?

We're getting into a Catch-22 discussion here... Until I fully understand what 
is needed, I can't really say what needs to be done :-).

At this stage the code works, is integrated into, and compiles cleanly against 
Linus' 2.6 git. My git is based on Linus' 2.6 as of yesterday.

I have done symbol cleaning changing the old yaffs names of the form 
yaffs_ScanBackwards() to yaffs_scan_backward() etc.

What I really need is someone to look at what's there and tell me if there are 
still style issues etc that need changing.

I know there is a style guide etc, but when we're talking about processing 15k 
loc then some of those rules might be slightly bendable.

>
> And if so, what is preventing you from doing those tasks right now to
> get the code into the .38 kernel merge?

My biggest problem is not fully understanding the process.
Knowing if I need to change anything else and whom to send what to,

Thanks. Your input is much appreciated.

Charles


