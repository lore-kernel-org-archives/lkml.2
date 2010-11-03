Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0KCRtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:49:21 -0400
Received: from kroah.org ([198.145.64.141]:39162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab0KCRtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:49:20 -0400
Date: Wed, 3 Nov 2010 10:46:07 -0700
From: Greg KH <greg@kroah.com>
To: cdhmanning@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
Message-ID: <20101103174607.GA6777@kroah.com>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288803204-3849-2-git-send-email-cdhmanning@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 05:53:16AM +1300, cdhmanning@gmail.com wrote:
> From: Charles Manning <cdhmanning@gmail.com>
> 
> Adding yaffs2 file system.
> 
> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
>  fs/yaffs2/Kconfig  |  190 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/yaffs2/Makefile |   17 +++++

Don't do this as your first patch, make it your last one.  Otherwise the
build will break when you apply this one to the tree.

Remember, we need to be able to have a correct build at every patch in
the whole development series, otherwise tools like 'git bisect' will not
work properly.

Also, is your goal to get this cleaned up good enough to get it into .38
in the "real" place in the kernel, or do you want to see it go through
staging and take a bit longer to get everything cleaned up properly
before moving to the "real" location?

Either is fine with me, just curious.

thanks,

greg k-h
