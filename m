Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1E3LMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:12:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:40547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1E3LMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:12:42 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 12:12:37 +0100
In-Reply-To: <20110530110432.GA21429@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530091536.GA2827@elte.hu>
	 <1306747629.2029.397.camel@i7.infradead.org>
	 <20110530095333.GA8461@elte.hu>
	 <1306750004.2029.413.camel@i7.infradead.org>
	 <20110530102502.GC17821@elte.hu>
	 <1306753314.2029.442.camel@i7.infradead.org>
	 <20110530110432.GA21429@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1306753958.2029.450.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 13:04 +0200, Ingo Molnar wrote:
> 
> That v2 changelog still seems to have an attitude though about the 
> ARCH=i386 and ARCH=x86_64 modifiers (thoroughly debunked both by 
> myself and others), so mind sending a v3 one which correctly and 
> fairly describes the situation? (or ack my variant which ought to be 
> pretty close) 

SIGWENCH; have to run. Back later. Can we make it something like

"This version preserves the legacy ARCH=i386/ARCH=x86_64 behaviour for
randconfig/oldconfig/all*config, although I believe that this *ought* to
be removed in the future, in favour of a generic method of overriding
config options — one that doesn't work *only* for one particular config
setting (CONFIG_64BIT), and *only* on one architecture (there's no
equivalent for mips/powerpc/s390/parisc/sparc to flip CONFIG_64BIT for
you)."

It's less of an 'attitude' but I think it clearly states the situation?

-- 
dwmw2

