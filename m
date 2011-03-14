Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1CNPtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:49:55 -0400
Received: from kroah.org ([198.145.64.141]:50399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1CNPty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:49:54 -0400
Date: Mon, 14 Mar 2011 08:42:47 -0700
From: Greg KH <greg@kroah.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Mike Waychison <mikew@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 00/12] google firmware support
Message-ID: <20110314154247.GB31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312035456.GA508@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312035456.GA508@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:54:56PM -0600, Matt Domsch wrote:
> On Fri, Mar 11, 2011 at 05:42:55PM -0800, Mike Waychison wrote:
> > Patchset summary
> > ================
> > 
> > Patches [1 through 6] refactor the 'efivars' module to let the "gsmi"
> > driver in patch [11] re-use the variable functionality.
> >
> > Patch [7] documents existing 'efivars' functionality that has been
> > present in the tree since 2004.
> 
> Very nice work Mike.  I can't test the efivars changes for another
> week or more, but reading it all, looks like a nice cleanup while
> allowing you to reuse the underlying code.

I agree, I've applied these 7 patches to my tree for merging with Linus
in .39.

I'll wait on the other 5 as I need acks from others to apply them.

thanks,

greg k-h
