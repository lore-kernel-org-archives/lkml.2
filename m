Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0JOO0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:26:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41856 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0JOO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:26:18 -0400
Date: Fri, 15 Oct 2010 16:26:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jan Engelhardt <jengelh@medozas.de>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: Process to push changes to include/linux/types.h
Message-ID: <20101015142617.GB25620@basil.fritz.box>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
 <878w1zc1ba.fsf@basil.nowhere.org>
 <20101015020134.e552d081.akpm@linux-foundation.org>
 <201010151215.49392.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010151215.49392.agruen@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 64-bit values align to 4-byte boundaries on some 32-bit architectures like x86 
AFAIK it's only on x86, no other architecture made this mistake in their
32bit ABI. But of course x86 is kind of important ...

> and to 8-byte boundaries on 64-bit architetures.  The new __aligned_64 type 
> enforces 8-byte alignment and so structs containing __aligned_64 values have 
> the same alignment on 32-bit and 64-bit architectures.  No conversions are 
> necessary between 32-bit user-space and a 64-bit kernel.

Rest looks good and could be put into Andrew's comment.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
