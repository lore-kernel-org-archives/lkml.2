Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2HUPNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:13:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2HUPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:13:24 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DUTXwliuHKEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pgRtvyofEwQA:10 a=meVymXHHAAAA:8 a=QyXUC8HyAAAA:8 a=zEOwz6LGedLIKXxCoz0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345562001.5069.5.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] perf: Enable function tracing for perf core
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Tue, 21 Aug 2012 11:13:21 -0400
In-Reply-To: <1345306530-25665-2-git-send-email-andi@firstfloor.org>
References: <1345306530-25665-1-git-send-email-andi@firstfloor.org>
	 <1345306530-25665-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 09:15 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> According to Steven R. there is no reason left to not support
> function tracing for the perf core. This makes it easier to debug
> perf.
> 
> Don't remove -pg for the x86 and generic perf core.

There's some new patches queued for 3.7 that has better function tracing
recursion protection. This should go after those.

Thanks,

-- Steve


