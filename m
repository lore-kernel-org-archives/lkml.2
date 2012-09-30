Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2I3OcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 10:32:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42556 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2I3OcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 10:32:07 -0400
Date: Sun, 30 Sep 2012 07:32:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Message-ID: <20120930143201.GA22107@kroah.com>
References: <2372445.fuIXicT4H0@tux200s>
 <CAKMK7uFm7YVMeUKUj4wmCeV4myYYODrp2XFDn5O8PHmjg3_U4g@mail.gmail.com>
 <20120928160656.GE2625@kroah.com>
 <12610424.iJ3m5UY2ZS@tux200s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12610424.iJ3m5UY2ZS@tux200s>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 01:15:38PM +0200, Andreas Sturmlechner wrote:
> > Ok, now reverted, thanks.
> > 
> > greg k-h
> 
> The same patch also breaks 3.0 for me. A 3.0.42 image with the patch
> reverted was fine, I checked with several restarts.
> 
> Sort of confirms there is something in >=3.5 that makes this thing work.

Ok, Daniel, should I also revert this on 3.0.y?

thanks,

greg k-h
