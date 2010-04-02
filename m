Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0DBW0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:26:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43938 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0DBW0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:26:12 -0400
Date: Fri, 2 Apr 2010 23:25:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
Message-ID: <20100402222516.GA11073@n2100.arm.linux.org.uk>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com> <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 12:43:00PM -0700, Linus Torvalds wrote:
> Russell is wrong.

Actually, in future threads you end up agreeing with my position...

> The fact that maybe some ARM6 cache coherency implementation is pure and 
> utter sh*t and never sees the changes without the same instruction that 
> happens to be a memory barrier on that architecture does not make that 
> cpu_relax() any more about memory barriers.

I'm not going to discuss it now; I'm on holiday.  Wait until mid-next
week on this and I'll respond with a fuller reply.
