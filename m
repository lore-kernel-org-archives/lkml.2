Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2CWVUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:20:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2CWVUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:20:04 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=WkbF08ShLlYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=a_U1oVfrAAAA:8 a=yRrtQyYWuDy2Cs--j98A:9 a=PUjeQqilurYA:10 a=k4qQewaewV0A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332537602.23924.74.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2, trace-cmd] Fix trace_printk for long integers
From: Steven Rostedt <rostedt@goodmis.org>
To: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2012 17:20:02 -0400
In-Reply-To: <1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com>
References: <1332411501-8059-1-git-send-email-wolfgang.mauerer@siemens.com>
	 <1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 11:18 +0100, Wolfgang Mauerer wrote:
> On 32 bit systems, a conversion of the trace_printk format string
> "%lu" -> "%llu" is intended (similar for %lx etc.) when a
> trace was taken on a machine with 64 bit long integers. However,
> the current code computes the bogus transformation "%lu" -> "%u".
> Fix this.
> 
> Besides that, the transformation is only required on systems
> that don't use 64 bits for long integers natively.
> 
> Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>

Applied, thanks!

-- Steve


