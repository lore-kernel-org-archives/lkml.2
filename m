Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1E3TDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:03:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:39029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1E3TDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:03:17 -0400
Date: Mon, 30 May 2011 20:03:08 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@localhost6.localdomain6
To: Theodore Tso <tytso@MIT.EDU>
cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
In-Reply-To: <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
Message-ID: <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu> <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu> <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Theodore Tso wrote:
> All this talk of how it's OK for randconfig to give you i386 50% of the time
> even when ARCH=x86_64 is specified is confusing me?  Maybe that
> was just intended to be sarcasm?

No, I don't believe that was ever actually said at all. Certainly not this 
year.

What was said was that with ARCH=x86, it's OK for randconfig to be random.

And that the legacy trick of using ARCH=i386 or ARCH=x86_64 as a hack to 
override *just* CONFOG_64BIT, although nobody has posted a patch which 
removes or breaks that, probably ought to be deprecated in favour of a 
more generic way to override config options - one that doesn't work only 
for *one* config option, and only on *one* architecture.

-- 
dwmw2

