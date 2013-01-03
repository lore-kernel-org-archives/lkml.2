Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3ACXlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:41:12 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34991 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3ACXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:41:07 -0500
Date: Thu, 3 Jan 2013 15:41:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Driver core __dev* removal patches for 3.8-rc2
Message-ID: <20130103234115.GA5824@kroah.com>
References: <20130103214114.GA12392@kroah.com>
 <20130103223801.GA4479@kroah.com>
 <CA+55aFxOjYvT6iEC51sga+rRy7Oc5oZ_P5OOz6PC=tytrp5gsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxOjYvT6iEC51sga+rRy7Oc5oZ_P5OOz6PC=tytrp5gsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:26:35PM -0800, Linus Torvalds wrote:
> On Thu, Jan 3, 2013 at 2:38 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Crap, I accidentally committed this file as part of the merge, sorry
> > about that.  I can either recreate the tree without this file in it, or
> > delete the file in a commit on top of this, or just let you remove the
> > file.  Which is easier for you?
> 
> Just recreate the tree.

Ok, will do.

> In fact, why isn't this all just one single scripted commit?

We tried that, but it messed up the coding styles of a number of
function, which caused some maintainers to rightfully complain, so I
redid the problem areas by hand.

thanks,

greg k-h
