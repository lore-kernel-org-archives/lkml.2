Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1E3LB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:01:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:44952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab1E3LB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:01:57 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 12:01:52 +0100
In-Reply-To: <20110530102502.GC17821@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530091536.GA2827@elte.hu>
	 <1306747629.2029.397.camel@i7.infradead.org>
	 <20110530095333.GA8461@elte.hu>
	 <1306750004.2029.413.camel@i7.infradead.org>
	 <20110530102502.GC17821@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306753314.2029.442.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 12:25 +0200, Ingo Molnar wrote:
> Oh, that needs fixing then.

Yeah, it was fixed in v2, which you should have received 15 minutes
before sending your mail at 12:25 +0200? 

> 	make ARCH=i386 oldconfig
> 	make ARCH=x86_64 oldconfig
> to switch a .config over from 32-bit to 64-bit. Please make sure this 
> still works with your patch applied.

Yes, that still works. The ARCH=i386 and ARCH=x86_64 behaviour should
not have changed at all; this patch should *only* affect ARCH=x86
behaviour (and make ARCH=x86 the default for x86 hosts, unless specified
on the make command line).

-- 
dwmw2

