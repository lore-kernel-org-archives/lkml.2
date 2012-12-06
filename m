Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab2LFQED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:04:03 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36847 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab2LFQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:04:01 -0500
Date: Thu, 6 Dec 2012 08:06:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Bin Wang <wbin00@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC -next] Fix the trailing blank space issue
Message-ID: <20121206160606.GA15256@kroah.com>
References: <1354784936-5647-1-git-send-email-wbin00@gmail.com>
 <20121206154219.GA24788@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206154219.GA24788@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 03:42:20PM +0000, Cong Ding wrote:
> On Thu, Dec 06, 2012 at 05:08:56PM +0800, Bin Wang wrote:
> > This patch removes the trailing white space in fs/sysfs/mount.c.
> > 
> > Signed-off-by: Bin Wang <wbin00@gmail.com>
> > ---
> >  fs/sysfs/mount.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> Hi Greg,
> 
> I am not sure it is really necessary to remove all the trailing blank spaces
> in the project. I have done a try by this shell command
> $ find . -iname '*.[ch]' | xargs sed 's/\s\+$//g' -i
> and find there are 2812 files/31712 lines with this issue. 

That's very true, why would you want to do this?

This comes up every 6 months or so on the linux-kernel mailing list,
please see the archives for previous responses to the topic.

If you want, just slowly send patches to the different subsystem
maintainers, to clean the issue up.

best of luck,

greg k-h
