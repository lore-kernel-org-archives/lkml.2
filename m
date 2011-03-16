Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1CPUor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:44:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1CPUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:44:43 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=9QXU0bjljTkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jij2qkgbLHVZRJPTW3MA:9 a=GeFUhpV58ZoamAw5RSDGHaFQ5tUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Typo in linux-2.6.38/arch/x86/kernel/entry_32.S
From: Steven Rostedt <rostedt@goodmis.org>
To: eric.valette@free.fr
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D811E5A.7080201@free.fr>
References: <4D80B7EE.40706@Free.fr>
	 <20110316195210.GA14675@home.goodmis.org>  <4D8118F7.5060107@free.fr>
	 <1300306954.16880.51.camel@gandalf.stny.rr.com>  <4D811E5A.7080201@free.fr>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Mar 2011 16:44:42 -0400
Message-ID: <1300308282.16880.57.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 21:32 +0100, Eric Valette wrote:


> > The old binutils never complained.
> 
> Anyway this show once again that the world like symetry and you better 
> remember it ;-) (lock/unlock, malloc free, ...)

Right, but it should be a warning not an error. If it worked before, why
not work now and just warn about it. This "BUG" existed forever in the
kernel, and its in more than one place. Having the compiler crash on the
first instance means you need to fix it and run the compiler again to
find the next instance and so on.

binutils made a fatal error in making this a bug and not an warning.

> 
> Probably a stable candidate for 2.6.38.1

Perhaps, but what about all older kernels. Now this version of binutils
does not work for bisecting.

-- Steve


