Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1JQUZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:25:07 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34909 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219Ab1JQUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:25:05 -0400
X-Sasl-enc: LqMxCWi932JVbFWwDb182OoHquK8WwNP3hdocRZhiR5E 1318883104
Date: Mon, 17 Oct 2011 13:24:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.7
Message-ID: <20111017202457.GA6952@kroah.com>
References: <20111017165654.GA5442@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017165654.GA5442@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 09:56:54AM -0700, Greg KH wrote:
> I'm announcing the release of the 3.0.7 kernel.
> 
> All users of the 3.0 kernel series must upgrade.
> 
> The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> Note, I've had some boot problems with this kernel, and I can't seem to
> narrow the issue down, but I think it's due to something not related to
> the kernel itself, but am not positive.  Please test to verify that I
> didn't mess something up.

Ok, this was a userspace problem on my machines, not a kernel issue,
I've resolved it (hint, don't have an old udev with a new libudev
package on the same system), and this kernel works fine for me now.

I've had some reports of it working for others as well, so we can chalk
this one up to my boxes being broken, not the kernel.

thanks,

greg k-h
