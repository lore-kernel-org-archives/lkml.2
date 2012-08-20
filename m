Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2HTJtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:49:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59197 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2HTJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:49:36 -0400
Date: Mon, 20 Aug 2012 11:49:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@ozlabs.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 27/74] lto: Mark EXPORT_SYMBOL symbols __visible
Message-ID: <20120820094935.GD16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-28-git-send-email-andi@firstfloor.org> <87txvy3vg3.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txvy3vg3.fsf@rustcorp.com.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Really, why?  Seems like a win to have them eliminated if unused.
> 
> Naively, I would think many cases of __visible should be #ifdef
> CONFIG_MODULES.  What am I missing?

It worked around some problem I forgot now :)

You're right it shouldn't be needed in theory for !MODULES. I'll double
check.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
