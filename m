Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab2K3Upb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:45:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52936 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031761Ab2K3UpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:45:10 -0500
Date: Fri, 30 Nov 2012 12:45:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Tony Lindgren <tony@atomide.com>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Chris Zankel <chris@zankel.net>,
        Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Fengguang Wu <fengguang.wu@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/2] init.h: Remove __dev* sections from the kernel
Message-ID: <20121130204506.GA32483@kroah.com>
References: <20121129184133.GA15110@kroah.com>
 <20121129184328.GB15110@kroah.com>
 <50B91965.5030007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B91965.5030007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 12:39:01PM -0800, H. Peter Anvin wrote:
> On 11/29/2012 10:43 AM, Greg Kroah-Hartman wrote:
> >From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >With the recent work to remove CONFIG_HOTPLUG, we are starting to get a
> >bunch of __devinit section warnings, despite CONFIG_HOTPLUG always being
> >enabled.  So, stop marking the sections entirely, by defining them away
> >the section markings in init.h
> >
> 
> Could we run a sed script over the kernel tree and generate patches
> to remove the markings completely?

Yes, we can, and Bill's been generating patches that way.  A number of
them are already in linux-next and I'll sweep the tree after 3.8-rc1 is
out and catch the rest.

thanks,

greg k-h
