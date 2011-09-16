Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1IPWdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:33:47 -0400
Received: from plane.gmane.org ([80.91.229.3]:53654 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab1IPWdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:33:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49266853"
From: Andi Kleen <andi@firstfloor.org>
To: Wolfgang Grandegger 
	<public-wg-5Yr1BZd7O62+XT7JhA+gdA@plane.gmane.org>
Cc: public-x86-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org,
        SocketCAN Core Mailing List 
	<public-socketcan-core-0fE9KPoRgkgATYTw5x5z8w@plane.gmane.org>,
        Willy Lambert 
	<public-lambert.willy-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        LKML <public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
References: <4E731565.5050307@grandegger.com>
Date: Fri, 16 Sep 2011 15:33:32 -0700
In-Reply-To: <4E731565.5050307@grandegger.com> (Wolfgang Grandegger's message
	of "Fri, 16 Sep 2011 11:22:45 +0200")
Message-ID: <m2y5xodsn7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Wolfgang Grandegger <wg-5Yr1BZd7O62+XT7JhA+gdA@public.gmane.org> writes:

> There are 64-bit systems out there, like the ATOM N450, which
> have ISA slots. This patch is necessary to get the "sja1000_isa"
> Socket-CAN driver working on such systems.

Really bad idea.

You'll get a zillion non 64bit safe unmaintained old ISA 
drivers then, a non trivial percentage of them will likely 
explode when just loaded. 

Not to speak of the warning load at allyesconfig builds.

Maybe define a ISA_64 or so.

But it's really a bad idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

