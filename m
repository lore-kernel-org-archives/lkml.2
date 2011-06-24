Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab1FXOpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:45:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759522Ab1FXOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:45:35 -0400
Subject: Re: [PATCH v2] x86, kconfig: Pick up the .config arch version in
 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Jun 2011 15:45:06 +0100
In-Reply-To: <4E049324.2000406@suse.cz>
References: <1306707270.2029.377.camel@i7.infradead.org>
		 <20110530072300.GA9802@elte.hu>
		 <1306745835.2029.389.camel@i7.infradead.org>
		 <20110530091536.GA2827@elte.hu>
	 <1306750170.2029.416.camel@i7.infradead.org> <4E049324.2000406@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308926707.28473.66.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 15:37 +0200, Michal Marek wrote:
> 
> This breaks all{mod,yes}config on 32bit and allnoconfig on 64bit (and 
> randconfig sometimes :)). The user expectation is that make 
> defconfig/allmodconfig/allyesconfig builds a kernel for their 
> architecture. You only handle defconfig below. 

It's a broken expectation.

Your architecture is x86. You are building the kernel in arch/x86.

Your architecture is not "i386 with PAE" or "i386 without PAE" or
"x86_64 with VT-x". Those are *configuration* options.

If you want the Aunt Tillie "configure for my machine" option, that's
something different. And uninteresting.

-- 
dwmw2

