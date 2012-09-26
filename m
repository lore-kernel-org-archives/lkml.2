Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2IZUFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:05:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2IZUFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:05:31 -0400
Date: Wed, 26 Sep 2012 13:05:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: staging tree closed for 3.7
Message-ID: <20120926200527.GC9994@kroah.com>
References: <20120926175606.GA10762@kroah.com>
 <20120926175634.GB10762@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206B20BED5D@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206B20BED5D@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 01:47:11PM -0500, H Hartley Sweeten wrote:
> On Wednesday, September 26, 2012 10:57 AM, Greg Kroah-Hartman wrote:
> > On Wed, Sep 26, 2012 at 10:56:06AM -0700, Greg Kroah-Hartman wrote:
> >> 
> >> With 3.6 about to be released, I've now closed the 3.7 staging-next tree
> >> for new features / cleanups.  It's bug-fixes only now until 3.7-rc1 is
> >> out.
> >
> > Oh, and if I've missed any patches that people have sent me already,
> > please let me know, because I don't have them anymore.
> 
> Greg,
> 
> What about my "staging: comedi: drivers: use comedi_fc.h cmdtest helpers"?
> 
> It's quite large but does have decent diffstat:
> 46 files changed, 766 insertions(+), 1997 deletions(-)

Care to resend it?  I thought that was part of the __user rework, my
apologies.

> If it doesn't apply due to conflicts, or you would rather just wait
> until 3.7-rc1, it's not a problem.
> 
> I have updated the patch to fix the typo Ian pointed out and to remove
> the Reported-by signoff from Dan if you would like me to repost it.

Please redo it and resend it, that must have been why I didn't apply it,
I was waiting for a newer version :)

thanks,

greg k-h
