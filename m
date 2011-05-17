Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1EQOsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:48:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1EQOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:48:05 -0400
Date: Tue, 17 May 2011 07:46:29 -0700
From: Greg KH <greg@kroah.com>
To: Arthur Machlas <arthur.machlas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reconsider including phc-linux patch to control voltages
Message-ID: <20110517144629.GC25545@kroah.com>
References: <BANLkTikn3OawHFO8y20sLuK_4LxOw7nQBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikn3OawHFO8y20sLuK_4LxOw7nQBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 09:39:23AM -0500, Arthur Machlas wrote:
> Hi, please cc me on any replies.
> 
> Five years ago a request was made[1] to include some patches from the
> phc-linux project. This request was rejected for reasons of stability,
> wasting dev time chasing bugs, and general discomfort. Mildly
> supportive suggestions were made to make it either a separate driver
> (it patches acpi-cpufreq) or call some 'tainted' flags.
> 
> It is currently included in the zen kernel, and now supports out of
> tree building making it somewhat unecessary to include, however, the
> dev's seem unable to keep up with newer kernels and releases are
> becoming infrequent. Users now seem to be modifying the patch to make
> sure it cleanly applies to newer kernels. Gentoo seems to be doing
> this at the distro level [2].
> 
> Just wondering if any circumstances have changed that would merit
> reconsidering the decision to not include the patches.
> 
> Many thanks,
> Arthur
> 
> [1] http://lkml.org/lkml/2007/9/2/119
> [2] http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-power/phc-intel/files/phc-intel-0.3.2.12.1-2.6.38.patch?view=markup


Why not submit it to the acpi developers in the proper format (i.e. what
Documentation/SubmittingPatches describes) and see how it goes?

thanks,

greg k-h
