Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab2DLTSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:18:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2DLTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:17:59 -0400
Date: Thu, 12 Apr 2012 12:17:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]NEXT:drivers:staging:ramster Fix typos and remove
 CONFIG_BROKEN in staging:ramster
Message-ID: <20120412191755.GD22154@kroah.com>
References: <1333982937-12929-1-git-send-email-user@Ideapad-Z560>
 <8f7aee45-fc5c-43b2-97cc-30c142927dc3@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f7aee45-fc5c-43b2-97cc-30c142927dc3@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 09:50:38AM -0700, Dan Magenheimer wrote:
> > From: Justin P. Mattock [mailto:justinmattock@gmail.com]
> > Sent: Monday, April 09, 2012 8:49 AM
> > To: dan.magenheimer@oracle.com
> > Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Justin P. Mattock
> > Subject: [PATCH]NEXT:drivers:staging:ramster Fix typos and remove CONFIG_BROKEN in staging:ramster
> > 
> > From: "Justin P. Mattock" <justinmattock@gmail.com>
> > 
> > The below patch fixes some typos that I found while reading. And also removes
> > CONFIG_BROKEN since it is no longer used.
> > 
> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> Hi Justin --
> 
> Thanks for your interest and for the patch!
> 
> The removal of CONFIG_BROKEN is already in GregKH's staging tree(s)
> and in linux-next, and will hopefully be in -rc3.
> 
> The comment typos do need to be fixed but I'm not sure if they should
> go through the staging tree or through trivial, but in either case
> consider them:

I already took them into my tree, and took out the CONFIG_BROKEN part of
this patch, so all is good :)

greg k-h
