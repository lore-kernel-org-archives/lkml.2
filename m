Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731Ab0EVCFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 22:05:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935688Ab0EVCFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 22:05:50 -0400
Date: Fri, 21 May 2010 19:03:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org
Subject: Re: [git pull] drm for 2.6.35-rc1 (revised)
In-Reply-To: <20100522120003.ee53af22.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1005211900230.3689@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1005190310010.1205@skynet.skynet.ie> <alpine.DEB.2.00.1005210718460.16929@skynet.skynet.ie> <alpine.LFD.2.00.1005211154120.3689@i5.linux-foundation.org> <20100522120003.ee53af22.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 May 2010, Stephen Rothwell wrote:
> 
> That being said, I did not get the mentioned warning for either an i386
> or x86_64 allmodconfig build - I wonder why not?  Compiler differences?
> Config differences? (See
> http://kisskb.ellerman.id.au/kisskb/buildresult/2617918/ and
> http://kisskb.ellerman.id.au/kisskb/buildresult/2617928/).
> 
> Ah, I did get it for an i386 defconfig build

You need to have 32-bit resources for it to trigger. So it ends up 
depending on CONFIG_PHYS_ADDR_T_64BIT. Which gets set for X86_PAE on x86.

		Linus
