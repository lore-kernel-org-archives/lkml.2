Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0FJXGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:06:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40682 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0FJXGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:06:10 -0400
Date: Fri, 11 Jun 2010 00:05:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, julia@diku.dk,
       linux-arm-kernel@lists.infradead.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sa1111: Prevent deadlock in resume path
Message-ID: <20100610230552.GE32362@n2100.arm.linux.org.uk>
References: <1274901104-22133-1-git-send-email-marek.vasut@gmail.com> <20100526201824.GA16418@n2100.arm.linux.org.uk> <20100610135609.GC4514@ucw.cz> <201006102349.12849.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006102349.12849.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 11:49:12PM +0200, Marek Vasut wrote:
> Even though my problem was fixed (yeah, sorry Russell, I didn't know
> the patch tracker was updated to support git-send-email), I have a
> question though.
> 
> I believe that Kernel-version is unnecessary. Isn't this information already 
> encoded in the git-send-emailed patch?

It's there so that gnu patches can be accepted, and the additional
information does help when applying hard to apply patches, particularly
if either the patch has aged or was generated against an old kernel
version.

Not only that, but it was once critical when we had 2.4 and 2.5/2.6
kernel patches going via the patch system.

Last point to make - and it's in similar vain to the KernelVersion
tag - is that it would be useful if people would tag pure fixes which
should be applied to previous kernels with a "Cc: <stable@kernel.org>"
tag along-side the existing sign-offs.  That allows the stable
maintainers to automatically pick up on these patches when they're
merged into mainline.
