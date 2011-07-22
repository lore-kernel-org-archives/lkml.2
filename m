Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1GVVLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:11:47 -0400
Received: from waste.org ([173.11.57.241]:56926 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab1GVVLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:11:46 -0400
Subject: Re: Nanosecond fs timestamp support: sad
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: NeilBrown <neilb@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110722205922.GS8006@one.firstfloor.org>
References: <1311271641.14555.114.camel@calx>
	 <m2pql2c0qz.fsf@firstfloor.org> <20110722163335.2df4f6ca@notabene.brown>
	 <1311363269.14555.261.camel@calx>
	 <20110722205922.GS8006@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 16:11:42 -0500
Message-ID: <1311369102.14555.268.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
> > Indeed. Only usefully exists on ext4 and requires extra system calls.
> 
> Not sure what you mean?  It's in stat(2), just like the timestamps.

I don't see anything that looks like a version or generation number in
either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
Pointer?

The only interface I'm aware of is the EXT?_IOC_GETVERSION interface.
Looks like that is supported by BTRFS.

-- 
Mathematics is the supreme nostalgia of our time.


