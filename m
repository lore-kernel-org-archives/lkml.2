Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1GVVre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:47:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48365 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1GVVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:47:33 -0400
Date: Fri, 22 Jul 2011 23:47:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, NeilBrown <neilb@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110722214732.GW8006@one.firstfloor.org>
References: <1311271641.14555.114.camel@calx> <m2pql2c0qz.fsf@firstfloor.org> <20110722163335.2df4f6ca@notabene.brown> <1311363269.14555.261.camel@calx> <20110722205922.GS8006@one.firstfloor.org> <1311369102.14555.268.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311369102.14555.268.camel@calx>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
> On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > > Indeed. Only usefully exists on ext4 and requires extra system calls.
> > 
> > Not sure what you mean?  It's in stat(2), just like the timestamps.
> 
> I don't see anything that looks like a version or generation number in
> either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
> Pointer?

Hmm you're right. I thought it was in there, but apparently not.
I think it should be added there though. We still have some unused 
fields.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
