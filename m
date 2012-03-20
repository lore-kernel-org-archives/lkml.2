Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab2CTNs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:48:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5275 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2CTNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:48:54 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=-21dhcYw4ikA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=u91xutOew97K9g1nNrIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332251333.23924.12.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/6] [GIT PULL] tracing: updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Mar 2012 09:48:53 -0400
In-Reply-To: <20120319144651.GA22223@gmail.com>
References: <20120314162629.118638243@goodmis.org>
	 <20120319105902.GA4154@gmail.com> <20120319144651.GA22223@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 15:46 +0100, Ingo Molnar wrote:

> Causes this build failure:
> 
>  (.text+0x46f2): undefined reference to `tracing_off'
>  debug_core.c:(.text+0xb418f): undefined reference to `tracing_is_on'
>  debug_core.c:(.text+0xb41bb): undefined reference to `tracing_off'
>  debug_core.c:(.text+0xb4394): undefined reference to `tracing_on'
>  debug_core.c:(.text+0xb47b0): undefined reference to `tracing_on'
>  make: *** [.tmp_vmlinux1] Error 1
> 
> config attached.
> 

Thanks, you just gave me a new config to add to my test suite :-)

CONFIG_RING_BUFFER=y
# CONFIG_FTRACE is not set

I have a patch that fixes this, I'll just run it through the other tests
to make sure it doesn't break anything else and push it to you.

Thanks,

-- Steve

