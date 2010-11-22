Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0KVTdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:33:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab0KVTdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:33:10 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=l99i6YEJd6sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Q9JxrfbZ-xq8baXpc-oA:9 a=bIv5PR5R9onhHzjjxCyMT58jQOYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace/ARM: add ARM support for C version of
 recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jreiser@BitWagon.com
In-Reply-To: <1290449586-1512-1-git-send-email-rabin@rab.in>
References: <1290449586-1512-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 22 Nov 2010 14:33:07 -0500
Message-ID: <1290454387.30543.304.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 23:43 +0530, Rabin Vincent wrote:
> Depending on the compiler version, ARM GCC calls the mcount function
> either __gnu_mcount_nc or mcount.
> 
> Also, arch/arm/kernel/ftrace.c references mcount like
> kernel/tracing/ftrace.c, so change the exclusion filter to match any
> ftrace.c
> 

Could you separate that out into two patches. I think this is too much
of a "side effect" for a "add arch" patch.

Thanks,

-- Steve


