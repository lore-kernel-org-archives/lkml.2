Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2JUQNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:13:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36945 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2JUQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:13:51 -0400
Date: Sun, 21 Oct 2012 09:14:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] firmware loader: misc changes
Message-ID: <20121021161414.GB23827@kroah.com>
References: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
 <CACVXFVObsMY6fngBCFoNhh0syuFNTOMwLxRqhhheiEYxzQ2Z=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVObsMY6fngBCFoNhh0syuFNTOMwLxRqhhheiEYxzQ2Z=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 03:55:45PM +0800, Ming Lei wrote:
> On Tue, Oct 9, 2012 at 12:01 PM, Ming Lei <ming.lei@canonical.com> wrote:
> > Hi,
> >
> > The first two are fixes' patch, the 3rd one is to enable
> > caching firmware for direct loading, and the last one is
> > a cleanup patch.
> >
> >  drivers/base/firmware_class.c |  266 +++++++++++++++++++++++------------------
> >  1 file changed, 151 insertions(+), 115 deletions(-)
> 
> Hi Greg,
> 
> Could you push the patchset or at least the first 3 fix patches
> onto 3.7-rc?
> 
> BTW: 3/4 is still a fix, since linus's direct loading breaks firmware cache
> which has been used by some drivers(such as: ath9k)

Yes, sorry, they are still in my queue, I was working on other fixes
for other subsystems this past week.  I'll get to these tomorrow.

greg k-h
