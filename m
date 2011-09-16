Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1IPOXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:23:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57916 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1IPOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:23:22 -0400
Date: Fri, 16 Sep 2011 16:23:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Improve lseek scalability v3
Message-ID: <20110916142319.GE7761@one.firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20110916130054.GA8997@parisc-linux.org> <201109161616.50004.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109161616.50004.andres@anarazel.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I sent an email containing benchmarks from Robert Haas regarding the Subject. 
> Looking at lkml.org I can't see it right now, Will recheck when I am at home.

I never saw that. Thanks for the data.

> You likely won't be able to see the bottlenecks with any of the released 
> postgres versions as there are bottlenecks fixed in HEAD that throttle way 
> before that.

FWIW we did some postgres testing on a 4 socket, but only with the heavily patched 
MOSBENCH version, which fixes various locking problems. Didn't run it with that
patchkit though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
