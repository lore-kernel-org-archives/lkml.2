Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2E2Jcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:32:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34582 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2E2Jck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:32:40 -0400
Date: Tue, 29 May 2012 18:32:31 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tty changes for the locking warnings.
Message-ID: <20120529093231.GA19992@kroah.com>
References: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
 <20120528112906.GA6188@kroah.com>
 <20120528131358.793c127e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528131358.793c127e@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 01:13:58PM +0100, Alan Cox wrote:
> On Mon, 28 May 2012 20:29:06 +0900
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, May 28, 2012 at 10:48:37AM +0100, Alan Cox wrote:
> > > Fix the tty locking warnings. This doesn't include the patches to the
> > > lock markup as I'm not sure which are the final valid ones there.
> > 
> > So this should take care of the issues people have reported?  Or are
> > Peter's patches still needed?
> 
> 
> These fix all the known actual locking issues. I'm not clear if one of
> the other various mark up patches are also needed to babysit the lockdep
> analyser

Ok, great, thanks for fixing this up.

But, it turns out I don't think I'll have internet access at all for the
next 4 days, due to travel arrangements, so can you send these directly
to Linus before 3.5-rc1 is out so they get in and we don't see a zillion
people complaining about it?

Feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

to them.

thanks,

greg k-h
