Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2CRPR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 11:17:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37645 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596Ab2CRPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 11:17:56 -0400
X-Sasl-enc: MfVqQuitz0wrYOLOBSoXFes5l1+TQbgoenmuLj/587fo 1332083875
Date: Sun, 18 Mar 2012 08:17:53 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Arnd Hannemann <arnd@arndnet.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Linux 2.6.32.59
Message-ID: <20120318151753.GA26492@kroah.com>
References: <20120317130953.GA16926@1wt.eu>
 <4F65E1A6.3020302@arndnet.de>
 <20120318132855.GK17033@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120318132855.GK17033@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 02:28:55PM +0100, Willy Tarreau wrote:
> Hi Arnd,
> 
> On Sun, Mar 18, 2012 at 02:22:46PM +0100, Arnd Hannemann wrote:
> > Hi,
> > 
> > Am 17.03.2012 14:09, schrieb Willy Tarreau:
> > 
> > > The updated 2.6.32.y git tree can be found at:
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
> > >   http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
> > > 
> > > The tree can be browsed on the gitweb interface:
> > >   http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y
> > 
> > Neither any commit after 2.6.32.58 nor the tag v2.6.32.59 seems to be available in the public git tree, yet.
> > Forgot to push?
> 
> Greg was not available for the final push when I sent the announce yesterday
> and I made a mistake in the pull request I sent him, further delaying the
> update. This will be sorted out soon, don't worry.

Sorry for the delay, they are now pushed out and should show up on the
public mirrors within minutes now.

greg k-h
