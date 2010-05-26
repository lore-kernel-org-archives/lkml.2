Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0EZR46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:56:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55127 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab0EZR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:56:56 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=JS33r_M2QPwA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=JsYIXgcXxp9bVlUgKHsA:9 a=7JLBLTUMl3jVDX5rHISKgp85lvgA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/8] tracing: further shrinking trace events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
References: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 26 May 2010 13:56:54 -0400
Message-ID: <1274896614.22648.247.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 16:22 +0800, Li Zefan wrote:
> patch 1-2: reduce per trace event foot print
> patch 3-5: convert some trace events to DEFINE_EVENT
> patch 6-8: do some cleanups and thus shrink text size a bit
> 
> Save ~5.7K in text and ~2.9K in data:
> 
>    text    data     bss     dec     hex filename
> 7018612 2034376 7251132 16304120         f8c7f8 vmlinux.o.orig
> 7012847 2031440 7251132 16295419         f8a5fb vmlinux.o
> 
> And save considerable memory allocated by trace_define_event().
> 
> -

Thanks Li!

I just pulled all but patch 5 in. Ted Tso said he'd take that one.

-- Steve


