Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324Ab0J1RlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:41:22 -0400
Received: from smtp.scorch.co.nz ([27.110.127.199]:46078 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750736Ab0J1RlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:41:16 -0400
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: How do I add yaffs file system to mainline?
Date: Fri, 29 Oct 2010 06:41:13 +1300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        gregkh <greg@kroah.com>
References: <201010290455.02390.manningc2@actrix.gen.nz> <20101028102641.d936aec8.randy.dunlap@oracle.com>
In-Reply-To: <20101028102641.d936aec8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010290641.13820.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 October 2010 06:26:41 Randy Dunlap wrote:
> On Fri, 29 Oct 2010 04:55:02 +1300 Charles Manning wrote:
> > YAFFS has been used for many years as a third-party patch-in.
> >
> > I have recently been through the exercise of changing all the symbols to
> > be more kernel friendly with the intention of mainlining into the linux
> > tree.
> >
> > The code is in git at
> > http://github.com/cdhmanning/linux-yaffs-integration/
>
> It's difficult to review & comment on a git tree.
> We prefer patches via email for review.
>
> > Thanks to CELF and Google for sponsoring the effort so far.
> >
> > What still needs to be done to mainline this?
> > Who do I need to approach?
>
> Either ask Stephen Rothwell to add the git tree to the linux-next daily
> tree or ask Greg KH to add it to the drivers/staging/ area.

Hi Randy

Thanks for the response. 

At this stage I'm hoping for some high level feedback about code layout etc. 
and don't expect an immediate approval. I expect to do some further code 
cleansing before getting a green light.

We're talking around 15k lines of code. Is a huge patch set the right way?
 I thought it would be more polite to invite people to look at git, rather 
than filling everyone's inboxes. 

If you do think I should send a patch set then should I send it to lkml or 
fsdevel?

Thanks

Charles

