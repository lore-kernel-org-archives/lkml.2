Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab0EDSnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:43:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab0EDSnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:43:13 -0400
X-Authority-Analysis: v=1.1 cv=Sj+DEJq9TvmrEz0yYf786F+83+V8ZKDvY/KsKt+Cs/8= c=1 sm=0 a=wjcUkYIaDT4A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=GZqp6Pu3WBXYK-MCyWcA:9 a=QDxgTzb-Hqx4aajGDaXFHUCD7esA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: How to write marker info in MMIO trace from kernel
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BE06933.9080202@lwfinger.net>
References: <4BE06933.9080202@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 14:42:59 -0400
Message-ID: <1272998579.9739.235.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 13:36 -0500, Larry Finger wrote:
> Stephen,
> 
> I hope you are the correct person for this question.
> 
> I would like to write information into the MMIO trace file similar to
> what the user space write to /sys/.../trace_marker would accomplish,
> however, I want to do it in place of printk statements in the driver I'm
> tracing. Do you have any suggestions on how to do this? I have tools to
> merge the trace dump with dmesg output, but the latter lags behind and I
> do not get good correlation.

You can use "trace_printk()". I think that is what you are looking for.

-- Steve


