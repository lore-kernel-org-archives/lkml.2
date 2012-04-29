Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2D2QUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:20:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61601 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2D2QUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:20:17 -0400
Date: Sun, 29 Apr 2012 09:20:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: update HOWTO for 2.6.x -> 3.x versioning
Message-ID: <20120429162013.GA6440@kroah.com>
References: <20120419061645.GA25127@www.outflux.net>
 <4F9C2B94.7080404@xenotime.net>
 <4F9C9680.7090205@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9C9680.7090205@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 08:16:48PM -0500, Rob Landley wrote:
> On 04/28/2012 12:40 PM, Randy Dunlap wrote:
> > On 04/18/2012 11:16 PM, Kees Cook wrote:
> > 
> >> The HOWTO document needed updating for the new kernel versioning. The
> >> git URI for -next was updated as well.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> > 
> > 
> > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Greg or Rob can merge...
> > 
> > Thanks.
> 
> Acked-by: Rob Landley <rob@landley.net>
> 
> And if Greg's already noticed it, I leave this one to him.  If not, I'll
> submit it next merge window.

It's already in my tree, and in linux-next, and will go to Linus for
3.5, and is marked to be backported to stable trees as well, so it
should all be taken care of.

thanks,

greg k-h
