Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0LJRqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:46:43 -0500
Received: from kroah.org ([198.145.64.141]:33625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab0LJRql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:46:41 -0500
Date: Fri, 10 Dec 2010 09:44:10 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [stable]  Linux 2.6.32.27+drm33.12
Message-ID: <20101210174410.GA11952@kroah.com>
References: <1291991638-8203-1-git-send-email-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291991638-8203-1-git-send-email-stefan.bader@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 03:33:58PM +0100, Stefan Bader wrote:
> I am announcing the release of the 2.6.32.27+drm33.12 stable tree.

I'm sorry, but that combination is anything but "stable".

> This tree is based on 2.6.32 and generally has all of the stable updates
> applied. Except those to the DRM subsystem, which was based on 2.6.33 and
> took updates from that upstream stable as long as that existed. It will
> continue to add patches to the DRM subsystem as long as they are valid
> according to the stable update rules (Documentation/stable_kernel_rules.txt).

You didn't follow that rule for the drm tree, so please, don't call this
a "stable" tree at all.

Also note the new name for longterm kernel releases, "longterm", not
"stable".

> DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

Why make developers do extra work for this old kernel tree?  That's not
very nice.

> This release contains patches from upstream 2.6.32.27, but dropped any patches
> to the DRM subsystem.

That doesn't seem wise, but hey, good luck with it, that's a
frankenkernel if I've ever seen one...

greg k-h
