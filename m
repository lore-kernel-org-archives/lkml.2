Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0DUTv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:51:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0DUTvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:51:23 -0400
Date: Wed, 21 Apr 2010 12:51:06 -0700
From: Greg KH <gregkh@suse.de>
To: Hedi Berriche <hedi@sgi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-ID: <20100421195106.GA15958@suse.de>
References: <4BCE579C.5070100@sgi.com>
 <4BCE5A73.3000904@sgi.com>
 <20100421102350.4c222e6b@lxorguk.ukuu.org.uk>
 <20100421165934.GN16427@zorg.emea.sgi.com>
 <20100421185852.3397f1da@lxorguk.ukuu.org.uk>
 <20100421191213.GR16427@zorg.emea.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421191213.GR16427@zorg.emea.sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 08:12:13PM +0100, Hedi Berriche wrote:
> Let's also not forget all those ephemeral user space tasks (udev and the likes)
> that will be spawned at boot time on even large systems with even more
> thousands of disks, arguably one might consider hack initrd and similar to work
> around the problem and set pid_max as soon as /proc becomes available but it's
> a bit of a PITA.

udev should properly handle large numbers of cpus and the tasks that it
spawns so as to not overload things.  If not, and you feel it is
creating too many tasks, please let the udev developers know and they
will be glad to work with you on this issue.

thanks,

greg k-h
