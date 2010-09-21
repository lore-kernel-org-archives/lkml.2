Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab0IUPrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:47:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0IUPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:47:32 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=efo-eZkTzUcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MSv9_SFoyvxCOx34NfQA:9 a=-XWFqhFosIIbzxuhkrlJ-lqPUaYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 09/10] jump label 11: add sparc64 support
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
In-Reply-To: <3b5b071fcdb2afb7f67cacecfa78b14c740278a7.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
	 <3b5b071fcdb2afb7f67cacecfa78b14c740278a7.1284733808.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 11:37:33 -0400
Message-ID: <1285083453.23122.1959.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 11:09 -0400, Jason Baron wrote:

> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 491e9d6..a81b04e 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -30,6 +30,7 @@ config SPARC
>  	select PERF_USE_VMALLOC
>  	select HAVE_DMA_ATTRS
>  	select HAVE_DMA_API_DEBUG
> +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
>  

David,

If you look at the thread for patch #8, do you still want that
 " if !CC_OPTIMIZE_FOR_SIZE"?

-- Steve


