Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab0KLLza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:55:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40479 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0KLLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:55:28 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=NFVsDZirmosA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uzy48p9BlfbZ6FlmGYUA:9 a=VjRkzBol-1BKtlenAQ4f7M8m4QkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace-view: Handle unknown events more gracefully
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
In-Reply-To: <4CDCF500.8000708@web.de>
References: <4CB758C1.8090906@web.de>  <4CDCF500.8000708@web.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 06:55:26 -0500
Message-ID: <1289562926.12418.393.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 09:04 +0100, Jan Kiszka wrote:
> Am 14.10.2010 21:23, Jan Kiszka wrote:
> > Kernel 2.6.35.7 generates invalid trace files due to
> > /sys/kernel/debug/tracing/events/scsi/scsi_dispatch_cmd_timeout/format
> > returning "FORMAT TOO BIG" (seems to be fixed in 2.6.36). This makes
> > pevent_data_event_from_type return NULL, and dereferencing of event
> > crashes the viewer.
> > 
> > Catch and report the error properly.
> 
> Ping...

Thanks! I just had 3 conferences in the last month and that put me way
behind in my email. I still have 1001 unread messages :-(

I'll pull this in today.

-- Steve


