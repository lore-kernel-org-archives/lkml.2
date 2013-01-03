Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3ACWh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:37:56 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35447 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3ACWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:37:52 -0500
Date: Thu, 3 Jan 2013 14:38:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Driver core __dev* removal patches for 3.8-rc2
Message-ID: <20130103223801.GA4479@kroah.com>
References: <20130103214114.GA12392@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103214114.GA12392@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 01:41:14PM -0800, Greg KH wrote:
> The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
> 
>   Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.8-rc2
> 
> for you to fetch changes up to 96611032705e2bddeafda85f11987f24e3a8336e:
> 
>   Merge 3.8-rc2 into driver-core-linus (2013-01-03 13:14:26 -0800)
> 

<snip>

>  drivers/i2c/Module.symvers                               |  59 ++++++++++++++++++++++++++++++++

Crap, I accidentally committed this file as part of the merge, sorry
about that.  I can either recreate the tree without this file in it, or
delete the file in a commit on top of this, or just let you remove the
file.  Which is easier for you?

Sorry about that, that's what I get for being on vacation for so long...

greg k-h
