Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380Ab2K3UnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:43:12 -0500
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:33605 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030301Ab2K3UnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:43:09 -0500
Subject: Re: [PATCH 1/2] init.h: Remove __dev* sections from the kernel
To: hpa@zytor.com (H. Peter Anvin)
Date: Fri, 30 Nov 2012 15:43:08 -0500
Cc: gregkh@linuxfoundation.org (Greg Kroah-Hartman),
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au (Rusty Russell),
        jim.cromie@gmail.com (Jim Cromie),
        borislav.petkov@amd.com (Borislav Petkov),
        akpm@linux-foundation.org (Andrew Morton),
        ak@linux.intel.com (Andi Kleen), mmarek@suse.cz (Michal Marek),
        tony@atomide.com (Tony Lindgren),
        kliegs@chromium.org (Jonathan Kliegman),
        chris@zankel.net (Chris Zankel), fengguang.wu@intel.com (Fengguang Wu),
        sam@ravnborg.org (Sam Ravnborg),
        linux-kbuild@vger.kernel.org (linux-kbuild)
In-Reply-To: <50B91965.5030007@zytor.com>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121130204308.7FDA08019A@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
> 
> On 11/29/2012 10:43 AM, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > With the recent work to remove CONFIG_HOTPLUG, we are starting to get a
> > bunch of __devinit section warnings, despite CONFIG_HOTPLUG always being
> > enabled.  So, stop marking the sections entirely, by defining them away
> > the section markings in init.h
> >
> 
> Could we run a sed script over the kernel tree and generate patches to 
> remove the markings completely?
> 

That's how I've been generating the patches to remove the markings --
except it's a perl script.

-- 
Bill
