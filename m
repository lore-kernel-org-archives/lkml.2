Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2K3S2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:28:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2K3S2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:28:18 -0500
Date: Fri, 30 Nov 2012 10:28:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Tony Lindgren <tony@atomide.com>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Chris Zankel <chris@zankel.net>,
        Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/2] init.h: Remove __dev* sections from the kernel
Message-ID: <20121130182813.GA17265@kroah.com>
References: <20121129184133.GA15110@kroah.com>
 <20121129184328.GB15110@kroah.com>
 <20121130181156.GA18287@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130181156.GA18287@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 07:11:56PM +0100, Sam Ravnborg wrote:
> On Thu, Nov 29, 2012 at 10:43:28AM -0800, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > With the recent work to remove CONFIG_HOTPLUG, we are starting to get a
> > bunch of __devinit section warnings, despite CONFIG_HOTPLUG always being
> > enabled.  So, stop marking the sections entirely, by defining them away
> > the section markings in init.h
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks for the review of this and the other patch.

greg k-h
