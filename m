Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2LNAFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:05:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab2LNAFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:05:38 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_aGYK8jRc_AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SI-C17Dh1R0A:10 a=BPktlKreZb_Nqj7D0JgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355443535.17101.383.camel@gandalf.local.home>
Subject: Re: [BUG] ftrace: available_filter_functions empty after unloading
 module
From: Steven Rostedt <rostedt@goodmis.org>
To: Piotr Haber <phaber@broadcom.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 13 Dec 2012 19:05:35 -0500
In-Reply-To: <1355427569.17101.380.camel@gandalf.local.home>
References: <50C0B236.4090200@broadcom.com>
	 <1354817428.17101.10.camel@gandalf.local.home>
	 <50C1A3A3.8030107@broadcom.com>
	 <1354888679.17101.36.camel@gandalf.local.home>
	 <50C5CB74.10008@broadcom.com>
	 <1355405698.17101.373.camel@gandalf.local.home>
	 <1355427569.17101.380.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 14:39 -0500, Steven Rostedt wrote:

> Can you tell me exactly what steps you took too?

I also have to ask: You weren't using systemtap or kprobes by chance
were you?

-- Steve


