Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1AWSGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:06:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58425 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1AWSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:06:03 -0500
Date: Sun, 23 Jan 2011 18:05:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KyongHo Cho <pullip.cho@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>,
        linux-kernel@vger.kernel.org, Ilho Lee <ilho215.lee@samsung.com>,
        linux-mm@kvack.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
Message-ID: <20110123180532.GA3509@n2100.arm.linux.org.uk>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com> <1295544047.9039.609.camel@nimitz> <20110120180146.GH6335@n2100.arm.linux.org.uk> <1295547087.9039.694.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295547087.9039.694.camel@nimitz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 10:11:27AM -0800, Dave Hansen wrote:
> On Thu, 2011-01-20 at 18:01 +0000, Russell King - ARM Linux wrote:
> > > The x86 version of show_mem() actually manages to do this without any
> > > #ifdefs, and works for a ton of configuration options.  It uses
> > > pfn_valid() to tell whether it can touch a given pfn.
> > 
> > x86 memory layout tends to be very simple as it expects memory to
> > start at the beginning of every region described by a pgdat and extend
> > in one contiguous block.  I wish ARM was that simple.
> 
> x86 memory layouts can be pretty funky and have been that way for a long
> time.  That's why we *have* to handle holes in x86's show_mem().  My
> laptop even has a ~1GB hole in its ZONE_DMA32:

If x86 is soo funky, I suggest you try the x86 version of show_mem()
on an ARM platform with memory holes.  Make sure you try it with
sparsemem as well...
