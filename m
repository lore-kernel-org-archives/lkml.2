Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1E3L6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:58:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:58208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1E3L6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:58:00 -0400
Date: Mon, 30 May 2011 12:57:52 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@localhost6.localdomain6
To: Theodore Tso <tytso@MIT.EDU>
cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
In-Reply-To: <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
Message-ID: <alpine.LFD.2.02.1105301255560.3164@localhost6.localdomain6>
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

> OK, so to clarify, what you want is for ARCH=xxx to always override
> whatever is in .config?  Are we all on the same page here?  I thought
> David was arguing that what was in .config should always be more
> important, since he regards "ARCH=xxxx" as "legacy".

I am saying that we should not have that redundancy at all. ATM we *only* 
have it for CONFIG_64BIT and *only* on x86, not others like ppc/sh/sparc 
etc.

-- 
dwmw2

