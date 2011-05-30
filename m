Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1E3Lz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:55:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:58183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1E3LzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:55:25 -0400
Date: Mon, 30 May 2011 12:55:19 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@localhost6.localdomain6
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
In-Reply-To: <20110530114214.GC22324@elte.hu>
Message-ID: <alpine.LFD.2.02.1105301248110.3164@localhost6.localdomain6>
References: <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org> <20110530091536.GA2827@elte.hu> <1306747629.2029.397.camel@i7.infradead.org> <20110530095333.GA8461@elte.hu> <1306750004.2029.413.camel@i7.infradead.org>
 <20110530102502.GC17821@elte.hu> <1306753314.2029.442.camel@i7.infradead.org> <20110530110432.GA21429@elte.hu> <1306753958.2029.450.camel@i7.infradead.org> <20110530114214.GC22324@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Ingo Molnar wrote:

> 
> What kind of replacement are you suggesting?

I suspect that
    make CONFIG_64BIT=y CONFIG_SATA_MV=y whateverconfig

ought to work for all the examples shown so far?

-- 
dwmw2

