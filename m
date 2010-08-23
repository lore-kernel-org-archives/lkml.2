Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0HWWrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:47:03 -0400
Received: from kroah.org ([198.145.64.141]:38432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0HWWrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:47:00 -0400
Date: Mon, 23 Aug 2010 15:22:16 -0700
From: Greg KH <greg@kroah.com>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] "vmscan: raise the bar to PAGEOUT_IO_SYNC stalls" to
 stable?
Message-ID: <20100823222216.GB13371@kroah.com>
References: <4C639E87.3050805@suse.cz>
 <20100819060516.GA14221@localhost>
 <20100819103139.GA31206@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819103139.GA31206@develbox.linuxbox.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 12:31:39PM +0200, Nikola Ciprich wrote:
> Hello everybody,
> is there any chance this one could also make it to long term
> supported 2.6.32 series?
> I guess this will take more work, but I guess there are quite
> a few users that would appreciate it much :)

It seems to also apply and build successfully on .32-stable, so I've
queued it up there as well.

thanks,

greg k-h
