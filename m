Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab0EEAcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:32:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab0EEAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:32:04 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=YcwJHCUm4PYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=ZIpjayG1Oey14ekqncQA:9 a=mxrJEv8YDSAAKWdsstUA:7 a=ZWWtJy5xkakKALKpXgHEFyhHuZQA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Tracing of power:power_start events doesn't work
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ronny =?ISO-8859-1?Q?Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4BDECD66.2010906@tu-dresden.de>
References: <4BDECD66.2010906@tu-dresden.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 20:31:57 -0400
Message-ID: <1273019517.22438.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 15:19 +0200, Ronny Tschüter wrote:
> Hello,
> 
> i use kernel version 2.6.33.2 (x86-64, Core 2 Duo) and the perf events 
> to track frequency and c states of my cpu. But if i want to trace 
> power:power_start events, it does not work. After typing
> 
> echo "power:power_start" | sudo tee set_event
> 
> on the console, the trace doesn't contain such events. 
> power:power_frequency and power:power_end events are reported correctly 
> by the system. I read in the mailing list that Robert Schoene had a 
> similiar problem, but with power:power_end events. Is there a known bug 
> regarding to trace_power_start methods in process.c?

Is this for perf or ftrace? I'm assuming you did this from the debugfs
tracing directory. The set_event file is for ftrace not perf.

-- Steve


