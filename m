Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab0EaTsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:48:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49177 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752929Ab0EaTsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:48:30 -0400
Date: Mon, 31 May 2010 14:48:49 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100531194849.GA5757@sgi.com>
References: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com> <4BFFEFA1.1020307@zytor.com> <20100528164725.GA29208@suse.de> <20100528194334.GA7707@sgi.com> <20100528222321.GC25513@suse.de> <20100528233623.GA11356@sgi.com> <20100529000526.GA30938@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100529000526.GA30938@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, May 28, 2010 at 05:05:26PM -0700, Greg KH wrote:
> On Fri, May 28, 2010 at 06:36:23PM -0500, Cliff Wickman wrote:
> > /proc/sgi_uv/bau_tunables would be a read/write file to display and change
> > nine threshold and delay values for tuning the BAU driver.
> > 
> > I like debugfs, except that a distro may not build the kernel with it
> > configured on.  The tunables should be available as administrative
> > options on a customer kernel, not just as a development tool.
> 
> All distros have debugfs turned on now, and mounted, due to the perf
> interface there, as well as a lot of other good debug information that
> is present.
> 
> So you don't have to worry about that.

Good to hear.  That makes the choice simple.
> 
...
> 
> So please, just put it in debugfs.
> 
> thanks,
> 
> greg k-h

Okay.  I moved the file to debugfs, and will re-submit the patch
momentarily.

-Cliff
-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
