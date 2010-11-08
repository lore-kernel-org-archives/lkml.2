Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0KHOSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:18:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab0KHOSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:18:38 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=1qZAFK7FH7YA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Y_2azpK4U78DZyq78gIA:9 a=J47mCEbZsYno2K0CdizqnXRMLXcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] powerpc: Add jump label support
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, Kumar Gala <kumar.gala@freescale.com>,
        "David S.Miller" <davem@davemloft.net>, jbaron@redhat.com,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
In-Reply-To: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
References: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Nov 2010 09:18:35 -0500
Message-ID: <1289225915.12418.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 15:12 +1100, Michael Ellerman wrote:
> This patch adds support for the new "jump label" feature.

Darn it! I wanted to port this!!!

;-)

> 
> Built for 64 & 32 bit, tested on 64 bit. Survives a kernel build under
> perf with all tracepoints enabled, and manual inspection of the patched
> code looks right. But still, lightly tested, YMMV.
> 
> Unlike x86 and sparc we just merrily patch the code with no locks etc,
> as far as I know this is safe, but I'm not really sure what the x86/sparc
> code is protecting against so maybe it's not.

Thanks, I'll give it a test on my electra as soon as I get a gcc 4.5.1
cross compiler working.

-- Steve


