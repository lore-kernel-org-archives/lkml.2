Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0HYLIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:08:25 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753249Ab0HYLIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:08:22 -0400
Date: Wed, 25 Aug 2010 06:08:15 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100825110815.GD3220@sgi.com>
References: <20100818183024.GZ3043@sgi.com>
 <4C6DB62C.9040105@zytor.com>
 <20100820135822.GA3220@sgi.com>
 <20100820150319.GB3220@sgi.com>
 <4C6EAA48.7070902@zytor.com>
 <20100821130757.GC3220@sgi.com>
 <4C72EB41.9000002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C72EB41.9000002@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So yes, this means adding an interface to the e820 allocator, even
> though it's scheduled to be replaced.  Because the new implementation
> will see the new interface and know they have to implement it, and the
> interface will make it clear just what exactly is expected of the
> implementation.

What is the new allocator called?  Who is developing it?  When do you
expect it to be introduced into the kernel?

Thanks,
Robin
