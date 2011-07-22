Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1GVU71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:59:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42547 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab1GVU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:59:25 -0400
Date: Fri, 22 Jul 2011 22:59:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: NeilBrown <neilb@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110722205922.GS8006@one.firstfloor.org>
References: <1311271641.14555.114.camel@calx> <m2pql2c0qz.fsf@firstfloor.org> <20110722163335.2df4f6ca@notabene.brown> <1311363269.14555.261.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311363269.14555.261.camel@calx>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Indeed. Only usefully exists on ext4 and requires extra system calls.

Not sure what you mean?  It's in stat(2), just like the timestamps.

As for XFS, btrfs etc. I guess it could be added there.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
