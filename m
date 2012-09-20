Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2ITNeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:34:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2ITNeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:34:06 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=VcgJFIKpTAAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=FfOpIHPiV7sA:10 a=VwQbUJbxAAAA:8 a=NPSMw-KFn6tVJm1s9SEA:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348148044.13080.59.camel@gandalf.local.home>
Subject: Re: [PATCH v2 1/3] tracing,x86: add a TSC trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 20 Sep 2012 09:34:04 -0400
In-Reply-To: <20120920085545.GA3497@gmail.com>
References: <1347499439.10751.78.camel@gandalf.local.home>
	 <1348004227-23575-1-git-send-email-dhsharp@google.com>
	 <20120920085545.GA3497@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 10:55 +0200, Ingo Molnar wrote:

> Looks useful and good otherwise:
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 

David,

Please submit a v3 with Ingo's updates and I'll go ahead and start
testing it.

Thanks!

-- Steve


