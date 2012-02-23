Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2BWUsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:48:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33733 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2BWUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:48:48 -0500
Date: Thu, 23 Feb 2012 12:48:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223204832.GA30322@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <20120222211928.GA4448@kroah.com>
 <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
 <20120222213253.GA25150@kroah.com>
 <20120223200905.GA5475@kroah.com>
 <4F46A1C4.90506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F46A1C4.90506@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 12:29:56PM -0800, H. Peter Anvin wrote:
> On 02/23/2012 12:09 PM, Greg Kroah-Hartman wrote:
> > 
> > I've applied this now to the 3.0 and 3.2-stable trees.  It looks like it
> > would work on the 2.6.32-stable tree, but it needs some tweaks, and as I
> > can't really test this, and the .32-stable tree is probably not going to
> > have problems in this area, I'll let someone else generate those patches
> > and test them if they feel it is needed there.
> > 
> 
> It doesn't seem to appear in the stable git tree... anywhere I can get
> your tree so I can test these out?

They are in the stable-queue git tree at:
	/pub/scm/linux/kernel/git/stable/stable-queue.git
on git.kernel.org

Testing them out would be great, if you want, I can knock up a git tree
with just these patches in it on 3.2.7 or anything else you need to test
with, if that makes it easier for you.

thanks,

greg k-h
